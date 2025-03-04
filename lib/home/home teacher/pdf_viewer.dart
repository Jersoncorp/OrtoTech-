import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PDFViewerPage extends StatefulWidget {
  final String pdfId;

  const PDFViewerPage({super.key, required this.pdfId, required String pdfUrl});

  @override
  _PDFViewerPageState createState() => _PDFViewerPageState();
}

class _PDFViewerPageState extends State<PDFViewerPage> {
  String? pdfUrl;

  @override
  void initState() {
    super.initState();
    _fetchPdfUrl();
  }

  // Fetch the PDF URL from Firestore
  Future<void> _fetchPdfUrl() async {
    try {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('uploads')
          .doc(widget.pdfId)
          .get();

      if (documentSnapshot.exists) {
        setState(() {
          pdfUrl = documentSnapshot['fileUrl'];
        });
      } else {
        // Handle case where the document doesn't exist
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('PDF not found')),
        );
      }
    } catch (e) {
      // Handle errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching PDF: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View PDF'),
      ),
      body: pdfUrl == null
          ? const Center(
              child:
                  CircularProgressIndicator()) // Show loading until the PDF URL is fetched
          : PDFView(
              filePath: pdfUrl, // Use the fetched URL
            ),
    );
  }
}
