import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class StudentsTab extends StatefulWidget {
  const StudentsTab({
    super.key,
    required this.teacherEmail,
    required this.classTitle,
  });

  final String teacherEmail;
  final String classTitle;

  @override
  _StudentsTabState createState() => _StudentsTabState();
}

class _StudentsTabState extends State<StudentsTab> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _emailController = TextEditingController();

  // Stream to fetch students who have already joined the class
  Stream<QuerySnapshot<Map<String, dynamic>>> _joinedStudentsStream() {
    return _firestore
        .collection('students')
        .where('enrolledSubjects',
            arrayContains: widget
                .classTitle) // Filter students by classTitle in enrolledSubjects
        .snapshots();
  }

  // Function to manually add a student
  Future<void> _addStudentManually(String studentEmail) async {
    try {
      // Check if the student is already in the students collection
      final existingStudentQuery = await _firestore
          .collection('students')
          .where('studentEmail', isEqualTo: studentEmail)
          .get();

      if (existingStudentQuery.docs.isNotEmpty) {
        // If the student already exists, update the enrolledSubjects field
        final studentDoc = existingStudentQuery.docs.first;
        List<dynamic> enrolledSubjectsList =
            List.from(studentDoc['enrolledSubjects'] ?? []);

        // Check if the student is already enrolled in this class
        if (!enrolledSubjectsList.contains(widget.classTitle)) {
          enrolledSubjectsList
              .add(widget.classTitle); // Add the classTitle to the list

          // Update the student document with the new enrolledSubjects list
          await _firestore.collection('students').doc(studentDoc.id).update({
            'enrolledSubjects': enrolledSubjectsList,
          });

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Matagumpay na naidagdag ang mag-aaral!')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Nasa klase na ang mag-aaral.')),
          );
        }
      } else {
        // If the student doesn't exist, create a new record
        await _firestore.collection('students').add({
          'studentEmail': studentEmail,
          'enrolledSubjects': [
            widget.classTitle
          ], // Add the classTitle to the enrolledSubjects list
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Matagumpay na naidagdag ang mag-aaral!')),
        );
      }

      // Trigger a UI update by refreshing the stream
      setState(() {});
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error sa pagdaragdag ng mag-aaral: $e')),
      );
    }
  }

  // Function to delete a student from Firestore
  Future<void> _deleteStudent(String studentEmail) async {
    try {
      // Query for the student document by their email
      final studentQuery = await _firestore
          .collection('students')
          .where('studentEmail', isEqualTo: studentEmail)
          .get();

      if (studentQuery.docs.isNotEmpty) {
        final studentDoc = studentQuery.docs.first;
        await studentDoc.reference.delete(); // Delete the student document
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Matagumpay na natanggal ang mag-aaral!')),
        );
        setState(() {}); // Refresh the UI after deletion
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error sa pagtanggal ng mag-aaral: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Add Student Manually
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Ipasok ang email ng mag-aaral',
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  if (_emailController.text.isNotEmpty) {
                    _addStudentManually(_emailController.text.trim());
                    _emailController.clear();
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Already Joined Students Section
          const Text(
            'Mga mag-aaral na nasa klase',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: _joinedStudentsStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                      child: Text('Walang mga Mag-aaral na sumali.'));
                }

                final students = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: students.length,
                  itemBuilder: (context, index) {
                    final student = students[index];
                    final data = student.data();
                    final enrolledSubjects =
                        List<String>.from(data['enrolledSubjects'] ?? []);

                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      child: ListTile(
                        title: Text(data['studentEmail']),
                        subtitle: Text(
                            'Naka-enroll sa: ${enrolledSubjects.join(', ')}'), // Display enrolled subject(s)
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            // Ask for confirmation before deleting the student
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text('Kumpirmahin'),
                                  content: const Text(
                                      'Sigurado ka bang gusto mong tanggalin ang mag-aaral?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('Hindi'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        _deleteStudent(data['studentEmail']);
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('Oo'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
