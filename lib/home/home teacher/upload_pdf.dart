import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

class UploadPdfPage extends StatefulWidget {
  final String subjectId;

  const UploadPdfPage({super.key, required this.subjectId});

  @override
  _UploadPdfPageState createState() => _UploadPdfPageState();
}

class _UploadPdfPageState extends State<UploadPdfPage> {
  late String _fileName;
  late String _filePath;
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    _fileName = '';
    _filePath = '';
  }

  // Method to pick the PDF file
  Future<void> _pickPdfFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      setState(() {
        _filePath = result.files.single.path!;
        _fileName = result.files.single.name;
      });
    }
  }

  // Method to upload the file to Firebase Storage and store metadata in Firestore
  Future<void> _uploadPdfFile() async {
    if (_filePath.isEmpty) return;

    setState(() {
      _isUploading = true;
    });

    try {
      // Create a reference to Firebase Storage for the file
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('pdfs/${widget.subjectId}/${_fileName}');

      // Upload the file to Firebase Storage
      await storageRef.putFile(File(_filePath));

      // Get the download URL of the uploaded file
      final downloadUrl = await storageRef.getDownloadURL();

      // Add the file's metadata (URL) to Firestore (in the 'uploads' collection)
      await FirebaseFirestore.instance.collection('uploads').add({
        'subjectId': widget.subjectId,
        'fileName': _fileName,
        'fileUrl': downloadUrl,
        'timestamp': FieldValue.serverTimestamp(),
      });

      setState(() {
        _isUploading = false;
      });

      // Show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('PDF uploaded successfully')),
      );
    } catch (e) {
      setState(() {
        _isUploading = false;
      });

      // Handle upload error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Upload failed: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload PDF File'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Button to pick PDF file
            ElevatedButton(
              onPressed: _pickPdfFile,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              child: const Text('Pick PDF File'),
            ),
            const SizedBox(height: 20),
            // Show selected file name
            if (_fileName.isNotEmpty) Text('Selected PDF: $_fileName'),
            const SizedBox(height: 20),
            // Upload button that gets disabled when uploading
            ElevatedButton(
              onPressed: _isUploading
                  ? null
                  : _uploadPdfFile, // Disable button if uploading
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              child: _isUploading
                  ? const CircularProgressIndicator() // Show loading indicator when uploading
                  : const Text('Upload PDF'),
            ),
            const SizedBox(height: 40),
            // Section to display uploaded files
            const Text('Uploaded PDFs'),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('uploads')
                    .where('subjectId',
                        isEqualTo: widget.subjectId) // Filter by subjectId
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text('No PDFs found.'));
                  }

                  // Build a list of PDFs from Firestore
                  final pdfDocs = snapshot.data!.docs;
                  return ListView.builder(
                    itemCount: pdfDocs.length,
                    itemBuilder: (context, index) {
                      final pdfData =
                          pdfDocs[index].data() as Map<String, dynamic>;
                      final fileName = pdfData['fileName'];
                      final fileUrl = pdfData['fileUrl'];

                      return ListTile(
                        title: Text(fileName),
                        trailing: IconButton(
                          icon: const Icon(Icons.download),
                          onPressed: () async {
                            // Trigger download
                            if (await canLaunch(fileUrl)) {
                              await launch(fileUrl); // Open file using URL
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Failed to download PDF')),
                              );
                            }
                          },
                        ),
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
}
