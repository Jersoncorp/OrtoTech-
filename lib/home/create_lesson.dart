import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

class CreateLessonPage extends StatefulWidget {
  final Function(Map<String, String>) onLessonCreated;

  const CreateLessonPage({super.key, required this.onLessonCreated});

  @override
  _CreateLessonPageState createState() => _CreateLessonPageState();
}

class _CreateLessonPageState extends State<CreateLessonPage> {
  final TextEditingController titleController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  File? _pdfFile; // To store the selected PDF file

  // Validation function for the lesson title
  String? validateInput(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    if (value.length < 3) {
      return 'Must be at least 3 characters';
    }
    return null;
  }

  // Function to handle PDF file picking
  Future<void> _pickPDF() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
    if (result != null) {
      setState(() {
        _pdfFile = File(result.files.single.path!);
      });
    }
  }

  // Function to upload the PDF to Firebase Storage and get the URL
  Future<String?> _uploadPDF() async {
    if (_pdfFile == null) return null;

    try {
      // Generate a unique file name for the PDF
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference ref =
          FirebaseStorage.instance.ref().child('lesson_pdfs/$fileName.pdf');
      UploadTask uploadTask = ref.putFile(_pdfFile!);
      TaskSnapshot snapshot = await uploadTask;
      String downloadURL = await snapshot.ref.getDownloadURL();
      return downloadURL;
    } catch (e) {
      print("Error uploading PDF: $e");
      return null;
    }
  }

  // Function to save the lesson data to Firestore
  Future<void> _saveLesson() async {
    if (_formKey.currentState!.validate()) {
      setState(() => isLoading = true);

      // Creating lesson object
      final newLesson = {
        'title': titleController.text,
        'dateCreated': DateTime.now().toIso8601String(),
      };

      // Upload PDF if selected and add the URL to the lesson object
      String? pdfUrl = await _uploadPDF();
      if (pdfUrl != null) {
        newLesson['pdfUrl'] = pdfUrl;
      }

      // Save the lesson to Firestore
      try {
        await FirebaseFirestore.instance.collection('lessons').add(newLesson);
        widget
            .onLessonCreated(newLesson); // Update parent screen with new lesson
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Lesson successfully created!')),
        );
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving lesson: $e')),
        );
      } finally {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create New Lesson"),
        backgroundColor: Colors.blue,
      ),
      body: Stack(
        children: [
          // Form UI to create lesson
          Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Lesson title input
                  TextFormField(
                    controller: titleController,
                    decoration: const InputDecoration(
                      labelText: 'Lesson Title',
                      border: OutlineInputBorder(),
                    ),
                    validator: validateInput,
                  ),
                  const SizedBox(height: 20),
                  // Pick PDF button
                  ElevatedButton(
                    onPressed: isLoading ? null : _pickPDF,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      backgroundColor: Colors.green,
                    ),
                    child: const Text('Pick PDF'),
                  ),
                  const SizedBox(height: 20),
                  // Show PDF file name if a PDF is selected
                  if (_pdfFile != null)
                    Text(
                      'Selected PDF: ${_pdfFile!.path.split('/').last}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  const SizedBox(height: 20),
                  // Save lesson button
                  ElevatedButton(
                    onPressed: isLoading ? null : _saveLesson,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      backgroundColor: Colors.blue,
                    ),
                    child: const Text('Create Lesson'),
                  ),
                ],
              ),
            ),
          ),
          // Loading spinner
          if (isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
