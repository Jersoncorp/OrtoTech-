import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'quiz.dart';

class MgaAralinPage extends StatefulWidget {
  final String studentEmail;

  const MgaAralinPage({super.key, required this.studentEmail});

  @override
  _MgaAralinPageState createState() => _MgaAralinPageState();
}

class _MgaAralinPageState extends State<MgaAralinPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late Stream<QuerySnapshot<Map<String, dynamic>>> subjectsStream;
  Map<String, bool> studentEnrolledMap =
      {}; // Track enrollment status for each subject
  List<Map<String, dynamic>> enrolledSubjects = []; // List of enrolled subjects
  bool isLoading = false; // Track the loading state
  TextEditingController subjectCodeController = TextEditingController();
  List<Map<String, dynamic>> subjectsList = []; // Cache subjects

  @override
  void initState() {
    super.initState();
    subjectsStream = _firestore.collection('subjects').snapshots();
    _fetchSubjects();
    _checkIfStudentEnrolled();
  }

  Future<void> _fetchSubjects() async {
    try {
      final subjectsSnapshot = await _firestore.collection('subjects').get();
      if (subjectsSnapshot.docs.isNotEmpty) {
        subjectsList = subjectsSnapshot.docs.map((doc) {
          return {
            'subjectId': doc.id,
            'subject': doc['subject'],
            'teacherEmail': doc['teacherEmail'],
            'teacherName': doc['teacherName'],
          };
        }).toList();
        setState(() {}); // Trigger UI update
      }
    } catch (e) {
      print("Error fetching subjects: $e");
    }
  }

  Future<void> _checkIfStudentEnrolled() async {
    try {
      // Fetch the student document by email
      final studentSnapshot = await _firestore
          .collection('students')
          .where('studentEmail', isEqualTo: widget.studentEmail)
          .get();

      if (studentSnapshot.docs.isNotEmpty) {
        List<String> enrolledSubjectIds = [];
        // Get the enrolled subjects list
        for (var doc in studentSnapshot.docs) {
          List<dynamic> enrolledSubjectsList = doc['enrolledSubjects'] ?? [];
          enrolledSubjectIds = List<String>.from(enrolledSubjectsList);
        }

        // Loop through all enrolled subjects (by name or ID) and fetch the subject details
        for (var enrolledSubject in enrolledSubjectIds) {
          final subjectSnapshot = await _firestore
              .collection('subjects')
              .where('subject',
                  isEqualTo: enrolledSubject) // Match by subject name
              .get();

          if (subjectSnapshot.docs.isNotEmpty) {
            // Assuming the subject name is unique in the 'subjects' collection
            final subject = subjectSnapshot.docs.first;
            setState(() {
              studentEnrolledMap[enrolledSubject] = true;
              enrolledSubjects.add({
                'subjectId': subject.id, // Save subject ID
                'subject': subject['subject'],
                'teacherEmail': subject['teacherEmail'],
                'teacherName': subject['teacherName'],
              });
            });
          }
        }
      }
    } catch (e) {
      print("Error checking enrollment: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error checking enrollment: $e')),
      );
    }
  }

  // Automatically enroll the student in a subject
  Future<void> _autoJoinSubject(String subjectCode) async {
    setState(() {
      isLoading = true; // Start loading
    });

    try {
      print("Attempting to enroll in subject with code: $subjectCode");

      // Fetch the subject document by the subject ID (document ID)
      final subjectSnapshot =
          await _firestore.collection('subjects').doc(subjectCode).get();
      print(subjectCode);

      if (!subjectSnapshot.exists) {
        print("Subject not found for code: $subjectCode");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid Subject Code')),
        );
        setState(() {
          isLoading = false; // Stop loading
        });
        return;
      }

      print("Subject found: ${subjectSnapshot['subject']}");

      // Get the subject name from the subjectSnapshot
      String subjectName = subjectSnapshot['subject'];

      // Fetch the student document by email
      final studentSnapshot = await _firestore
          .collection('students')
          .where('studentEmail', isEqualTo: widget.studentEmail)
          .get();

      if (studentSnapshot.docs.isEmpty) {
        // If student doesn't exist, create a new document for the student
        print("New student, creating document...");

        // Create a new student document with the subject name (not the code)
        await _firestore.collection('students').add({
          'studentEmail': widget.studentEmail,
          'enrolledSubjects': [subjectName], // Add the subject name to the list
        });

        setState(() {
          // Update UI to reflect the new enrollment
          studentEnrolledMap[subjectCode] = true;
          enrolledSubjects.add({
            'subjectId': subjectCode,
            'subject':
                subjectName, // Use the subject name instead of subject code
            'teacherEmail': subjectSnapshot['teacherEmail'],
            'teacherName': subjectSnapshot['teacherName'],
          });
          isLoading = false;
        });

        // Clear the text field
        subjectCodeController.clear();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Successfully joined the subject!')),
        );

        return;
      }

      // If student exists, continue with the enrollment process
      final studentDoc = studentSnapshot.docs.first;
      List<dynamic> enrolledSubjectsList = studentDoc['enrolledSubjects'] ?? [];

      // Check if the student is already enrolled
      if (enrolledSubjectsList.contains(subjectName)) {
        print("Student is already enrolled in this subject");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Already enrolled in this subject.')),
        );
        setState(() {
          isLoading = false; // Stop loading
        });
        return;
      }

      // Add the subject name to the student's enrolledSubjects
      enrolledSubjectsList.add(subjectName); // Add the subject name

      // Update the student document with the new enrolledSubjects list
      await _firestore.collection('students').doc(studentDoc.id).update({
        'enrolledSubjects': enrolledSubjectsList,
      });

      setState(() {
        studentEnrolledMap[subjectCode] = true;
        enrolledSubjects.add({
          'subjectId': subjectCode,
          'subject': subjectName, // Use the subject name
          'teacherEmail': subjectSnapshot['teacherEmail'],
          'teacherName': subjectSnapshot['teacherName'],
        });
        isLoading = false;
      });

      // Clear the text field
      subjectCodeController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Successfully joined the subject!')),
      );
    } catch (e) {
      print("Error enrolling in subject: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error enrolling in subject: $e')),
      );
      setState(() {
        isLoading = false;
      });
    }
  }

  // Navigate to the quiz page
  void _goToQuizPage(String subjectName) async {
    try {
      // Print the subjectName to check if it's correct
      print('Subject Name: $subjectName');

      // Fetch the subject document by subject name
      final subjectSnapshot = await _firestore
          .collection('subjects')
          .where('subject',
              isEqualTo: subjectName) // Use subject name to query Firestore
          .get();

      if (subjectSnapshot.docs.isNotEmpty) {
        // Get the first matching subject document
        final subjectDoc = subjectSnapshot.docs.first;
        final subjectId =
            subjectDoc.id; // Get the real subject ID from Firestore

        // Fetch the student document by email
        final studentSnapshot = await _firestore
            .collection('students')
            .where('studentEmail', isEqualTo: widget.studentEmail)
            .get();

        if (studentSnapshot.docs.isNotEmpty) {
          // Get the enrolled subjects list from the student document
          final studentDoc = studentSnapshot.docs.first;
          List<dynamic> enrolledSubjectsList =
              studentDoc['enrolledSubjects'] ?? [];

          // Check if the student is enrolled in the subject by name, not ID
          bool isEnrolled = enrolledSubjectsList.contains(subjectName);

          if (isEnrolled) {
            // If the student is enrolled in the subject, navigate to the quiz page
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => QuizPage(
                  quizTitle:
                      subjectId, // Pass the real subject ID to the quiz page
                  studentId: widget.studentEmail,
                ),
              ),
            );
          } else {
            // If the student is not enrolled, show a snack bar
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('You are not enrolled in this subject.')),
            );
          }
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Subject not found in database.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error checking enrollment: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 224, 222, 222),
      appBar: AppBar(
        title: const Text('Mga Aralin'),
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: subjectsStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text('No available subjects.'));
            }

            return SingleChildScrollView(
              child: Column(
                children: [
                  // Subject Code enrollment UI
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Join a Subject',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          controller: subjectCodeController,
                          decoration: const InputDecoration(
                            labelText: 'Enter Subject Code',
                          ),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: isLoading
                              ? null // Disable button while loading
                              : () async {
                                  String subjectCode =
                                      subjectCodeController.text.trim();
                                  if (subjectCode.isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text('Enter a valid code.')),
                                    );
                                    return;
                                  }
                                  await _autoJoinSubject(subjectCode);
                                },
                          child: isLoading
                              ? const CircularProgressIndicator()
                              : const Text('Join Subject'),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Display Enrolled Subjects
                  const Text(
                    'Enrolled Subjects',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: enrolledSubjects.length,
                    itemBuilder: (context, index) {
                      final subject = enrolledSubjects[index];

                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        child: ListTile(
                          title: Text(subject['subject']),
                          subtitle: Text('Teacher: ${subject['teacherName']}'),
                          trailing: IconButton(
                            icon: const Icon(Icons.quiz),
                            onPressed: () {
                              _goToQuizPage(subject['subject']);
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
