import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart'; // Added import
import 'classroom_details.dart';

class ClassroomPage extends StatefulWidget {
  const ClassroomPage({super.key});

  @override
  _ClassroomPageState createState() => _ClassroomPageState();
}

class _ClassroomPageState extends State<ClassroomPage> {
  bool isCreatingNewClass = false;
  final TextEditingController subjectController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  String teacherName = "Hindi Kilalang Guro";

  @override
  void initState() {
    super.initState();
    _fetchTeacherName();
  }

  Future<void> _fetchTeacherName() async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        final userData = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        setState(() {
          teacherName = userData['name'] ?? "Hindi Kilalang Guro";
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error sa pagkuha ng pangalan ng guro: $e')),
      );
    }
  }

  Future<void> _addNewSubject() async {
    final String subjectName = subjectController.text.trim();
    final String description = descriptionController.text.trim();

    if (subjectName.isEmpty || description.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Ang parehong mga patlang ay kinakailangan')),
      );
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    final teacherEmail = user?.email ?? 'Hindi Kilalang Guro';

    final newSubject = {
      'subject': subjectName,
      'description': description,
      'teacherName': teacherName,
      'teacherEmail': teacherEmail,
      'createdAt': FieldValue.serverTimestamp(),
    };

    try {
      final docRef = await FirebaseFirestore.instance
          .collection('subjects')
          .add(newSubject);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Matagumpay na naidagdag ang paksa!')),
      );

      setState(() {
        isCreatingNewClass = false;
        subjectController.clear();
        descriptionController.clear();
      });

      // After adding the subject, display the Subject ID
      final subjectId = docRef.id;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Subject ID: $subjectId')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  // Function to copy text to clipboard
  void copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text)).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nakopya ang Subject ID sa clipboard!')),
      );
    });
  }

  Future<void> _deleteSubject(String subjectId) async {
    try {
      // Query for the subject document by its ID
      final subjectDoc = await FirebaseFirestore.instance
          .collection('subjects')
          .doc(subjectId) // Use the subjectId to target the document directly
          .get();

      if (subjectDoc.exists) {
        await subjectDoc.reference.delete(); // Delete the subject document
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Matagumpay na natanggal klase!')),
        );
        setState(() {}); // Refresh the UI after deletion
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Walang klase na natagpuan.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error sa pagtanggal ng klase: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        titleTextStyle: const TextStyle(
          color: Colors.black,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TextField(
              decoration: InputDecoration(
                hintText: 'Hanapinin Dito',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  isCreatingNewClass = !isCreatingNewClass;
                });
              },
              style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white),
              child: Text(isCreatingNewClass
                  ? 'Kanselahin'
                  : 'Lumikha ng Bagong Klase'),
            ),
            const SizedBox(height: 20),
            if (isCreatingNewClass)
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 229, 228, 255),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(color: Colors.grey.shade300, blurRadius: 5)
                  ],
                ),
                child: Column(
                  children: [
                    TextField(
                      controller: subjectController,
                      decoration: const InputDecoration(
                        labelText: 'Paksa',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Paglalarawan',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _addNewSubject,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        backgroundColor: Colors.blue,
                      ),
                      child: const Text('Idagdag ang Paksa'),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 20),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('subjects')
                    .orderBy('createdAt', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return const Center(
                        child: Text('Error sa paglo-load ng mga paksa.'));
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(
                        child: Text('Walang magagamit na mga paksa.'));
                  }

                  final classes = snapshot.data!.docs.map((doc) {
                    return {
                      'subject': doc['subject'],
                      'description': doc['description'],
                      'teacherName': doc['teacherName'],
                      'teacherEmail': doc['teacherEmail'],
                      'subjectId': doc.id,
                    };
                  }).toList();

                  return ListView.builder(
                    itemCount: classes.length,
                    itemBuilder: (context, index) {
                      final classItem = classes[index];
                      return buildClassCard(
                        context,
                        classItem['subject']!,
                        classItem['description']!,
                        classItem['teacherName']!,
                        classItem['teacherEmail']!,
                        classItem['subjectId']!,
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildClassCard(
      BuildContext context,
      String subject,
      String description,
      String teacherName,
      String teacherEmail,
      String subjectId) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ClassroomDetailsPage(
              classTitle: subject,
              subjectId: subjectId, // Passing subjectId to the next page
              teacherEmail: teacherEmail,
            ),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(subject,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(description),
              const SizedBox(height: 8),
              Text(
                'Teacher: $teacherName',
                style: const TextStyle(color: Colors.blue),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text('ID: $subjectId'), // Displaying subjectId here
                  IconButton(
                    onPressed: () => copyToClipboard(subjectId),
                    icon: const Icon(Icons.copy),
                    tooltip: 'Copy Subject ID',
                  ),
                  IconButton(
                    onPressed: () =>
                        _deleteSubject(subjectId), // Pass the subjectId here
                    icon: const Icon(Icons.delete),
                    tooltip: 'Delete Subject', // Corrected tooltip
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
