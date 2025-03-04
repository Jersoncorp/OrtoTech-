import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class DisplayPdfPage extends StatefulWidget {
  final String subjectId;

  const DisplayPdfPage({super.key, required this.subjectId});

  @override
  _DisplayPdfPageState createState() => _DisplayPdfPageState();
}

class _DisplayPdfPageState extends State<DisplayPdfPage> {
  String? _pdfUrl;

  @override
  void initState() {
    super.initState();
    _fetchPdfUrl();
  }

  // Fetch PDF file URL from Firestore
  Future<void> _fetchPdfUrl() async {
    try {
      // Retrieve the document from Firestore that stores the URL of the PDF
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection(
              'uploads') // Assuming your Firestore collection is named 'pdfs'
          .doc(widget.subjectId)
          .get();

      if (doc.exists) {
        String fileName = doc[
            'fileName']; // Assuming the Firestore document stores the file name
        // Fetch the URL from Firebase Storage using the file name
        String downloadUrl = await FirebaseStorage.instance
            .ref('pdfs/${widget.subjectId}/$fileName')
            .getDownloadURL();

        setState(() {
          _pdfUrl = downloadUrl; // Store the URL for display
        });
      }
    } catch (e) {
      // Handle any errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching PDF: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Display PDF File'),
      ),
      body: _pdfUrl == null
          ? const Center(child: CircularProgressIndicator())
          : PDFView(
              filePath: _pdfUrl,
            ),
    );
  }
}
