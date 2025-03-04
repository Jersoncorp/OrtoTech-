import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import 'create_activity.dart';
import 'upload_pdf.dart';
import 'widgets/reports_widget.dart';
import 'widgets/students_widget.dart';

class ClassroomDetailsPage extends StatefulWidget {
  final String classTitle;
  final String subjectId;
  final String teacherEmail;

  const ClassroomDetailsPage({
    super.key,
    required this.classTitle,
    required this.subjectId,
    required this.teacherEmail,
  });

  @override
  _ClassroomDetailsPageState createState() => _ClassroomDetailsPageState();
}

class _ClassroomDetailsPageState extends State<ClassroomDetailsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    searchController.addListener(_filterSearchResults);
  }

  @override
  void dispose() {
    _tabController.dispose();
    searchController.dispose();
    super.dispose();
  }

  void _filterSearchResults() {
    // Implement the search functionality based on activities or students
  }

  Stream<QuerySnapshot> _quizzesStream() {
    return FirebaseFirestore.instance
        .collection('quizzes')
        .where('subjectId', isEqualTo: widget.subjectId)
        .snapshots();
  }

  Stream<QuerySnapshot> _uploadsStream() {
    return FirebaseFirestore.instance
        .collection('uploads')
        .where('subjectId', isEqualTo: widget.subjectId)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.classTitle),
        backgroundColor: Colors.white,
        elevation: 0,
        titleTextStyle: const TextStyle(
          color: Colors.black,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // Handle notifications
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.black,
          labelColor: Colors.black,
          tabs: const [
            Tab(text: 'Mga Gawain'),
            Tab(text: 'Mga Mag-aaral'),
            Tab(text: 'Ulat'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildActivitiesTab(),
          StudentsTab(
            classTitle: widget.classTitle,
            teacherEmail: widget.teacherEmail,
          ),
          ReportsTab(
            classTitle: widget.classTitle,
          ),
        ],
      ),
    );
  }

  Widget _buildActivitiesTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CreateActivityPage(
                            onCreated: _onQuizCreated,
                            title: 'Gumawa ng Bagong Gawain',
                            subjectId: widget.subjectId,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text(
                      'Gumawa ng Bagong Gawain',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 13),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UploadPdfPage(
                            subjectId: widget.subjectId,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text(
                      'Upload PDF File',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 13),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _quizzesStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No activities found.'));
                }

                final activities = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: activities.length,
                  itemBuilder: (context, index) {
                    final doc = activities[index];
                    final quizData = doc.data() as Map<String, dynamic>;
                    final quizId = doc.id;

                    return _buildActivityCard(
                      name: quizData['title'],
                      category: 'Activity',
                      dateCreated: (quizData['dateCreated'] as Timestamp)
                          .toDate()
                          .toString(),
                      quizTitle: quizData['title'],
                      quizData: quizData,
                      quizId: quizId,
                      onDelete: () async {
                        await FirebaseFirestore.instance
                            .collection('quizzes')
                            .doc(quizId)
                            .delete();
                      },
                    );
                  },
                );
              },
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _uploadsStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No PDFs uploaded.'));
                }

                final uploads = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: uploads.length,
                  itemBuilder: (context, index) {
                    final doc = uploads[index];
                    final pdfData = doc.data() as Map<String, dynamic>;
                    final pdfId = doc.id;

                    return _buildPdfCard(
                      name: pdfData['fileName'],
                      pdfUrl: pdfData['fileUrl'],
                      pdfId: pdfId,
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

  Widget _buildActivityCard({
    required String name,
    required String category,
    required String dateCreated,
    required String quizTitle,
    required Map<String, dynamic> quizData,
    required String quizId,
    required VoidCallback onDelete,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: const CircleAvatar(),
        title: Text('Pangalan: $name'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Categorya: $category'),
            Text('Petsa ng Paggawa: $dateCreated'),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.black),
              onPressed: () {
                _editActivity(quizData, quizId);
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.black),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPdfCard({
    required String name,
    required String pdfUrl,
    required String pdfId,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: const Icon(Icons.picture_as_pdf, color: Colors.red),
        title: Text('PDF: $name'),
        trailing: IconButton(
          icon: const Icon(Icons.download),
          onPressed: () async {
            // Trigger download
            Uri url = Uri.parse(pdfUrl);
            if (await canLaunch(url.toString())) {
              await launch(url.toString());
            } else {
              // Show error if the URL cannot be opened
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Failed to download PDF')),
              );
            }
          },
        ),
      ),
    );
  }

  void _editActivity(Map<String, dynamic> quizData, String quizId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateActivityPage(
          onCreated: (updatedQuizData) {
            setState(() {
              // Refresh UI after editing
            });
          },
          title: 'I-edit ang Gawain',
          subjectId: widget.subjectId,
          quizData: {
            ...quizData,
            'id': quizId,
          },
        ),
      ),
    );
  }

  void _onQuizCreated(Map<String, dynamic> quiz) {
    setState(() {
      // Refresh UI after a quiz is created
    });
  }
}
