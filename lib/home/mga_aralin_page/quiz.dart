import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

class QuizPage extends StatefulWidget {
  final String quizTitle;
  final String studentId;

  const QuizPage({super.key, required this.quizTitle, required this.studentId});

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  late Future<List<DocumentSnapshot>> _quizList;
  Future<DocumentSnapshot>? _selectedQuizData;
  int _currentQuestionIndex = 0;
  final Map<int, String?> _userAnswers = {};
  String _noQuizzesMessage = '';

  @override
  void initState() {
    super.initState();

    // Initialize _quizList by fetching quizzes from Firestore
    _quizList = FirebaseFirestore.instance
        .collection('quizzes')
        .where('subjectId', isEqualTo: widget.quizTitle)
        .get()
        .then((querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        // Return the docs as a List<DocumentSnapshot>
        return querySnapshot.docs;
      } else {
        setState(() {
          _noQuizzesMessage = 'Wala pang pagsusulit para sa paksang ito.';
        });
        return <DocumentSnapshot>[]; // Return an empty list if no quizzes
      }
    }).catchError((e) {
      setState(() {
        _noQuizzesMessage = 'Hindi nahanap sa pagkuha ng mga pagsusulit: $e';
      });
      return <DocumentSnapshot>[]; // Return an empty list on error
    });
  }

  // Stream to listen to uploads collection based on quizTitle
  Stream<QuerySnapshot> _uploadsStream() {
    return FirebaseFirestore.instance
        .collection('uploads')
        .where('subjectId', isEqualTo: widget.quizTitle)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        centerTitle: true,
        elevation: 10.0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Mga Pagsusulit',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            // Quiz List
            FutureBuilder<List<DocumentSnapshot>>(
              future: _quizList,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text(': ${snapshot.error}'));
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  // Display message when no quizzes are found
                  return Center(child: Text(_noQuizzesMessage));
                }

                final quizDocs = snapshot.data!;

                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: quizDocs.length,
                  itemBuilder: (context, index) {
                    final quizData =
                        quizDocs[index].data() as Map<String, dynamic>;
                    final quizTitle = quizData['title'] ?? 'Untitled Quiz';

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        elevation: 5.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          title: Text(
                            quizTitle,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                          subtitle: const Text("I-tap para magsimula",
                              style: TextStyle(color: Colors.blueGrey)),
                          leading: const Icon(Icons.quiz, color: Colors.blue),
                          onTap: () {
                            setState(() {
                              _selectedQuizData = Future.value(quizDocs[index]);
                              _currentQuestionIndex = 0;
                            });
                          },
                        ),
                      ),
                    );
                  },
                );
              },
            ),

            const SizedBox(height: 26),

            // Container for Uploaded PDFs
            Container(
              padding: const EdgeInsets.all(8.0),
              color: Colors.grey[100],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Mga Gawaing Aktibidad',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  const SizedBox(height: 8),
                  StreamBuilder<QuerySnapshot>(
                    stream: _uploadsStream(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        return Center(child: Text(': ${snapshot.error}'));
                      }
                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return const Center(
                            child: Text('Walang available na mga PDF.'));
                      }

                      // Process the data and display the uploaded PDFs
                      final uploadDocs = snapshot.data!.docs;
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: uploadDocs.length,
                        itemBuilder: (context, index) {
                          final uploadData =
                              uploadDocs[index].data() as Map<String, dynamic>;
                          final pdfName =
                              uploadData['fileName'] ?? 'No name available';
                          final pdfUrl = uploadData['fileUrl'] ?? '';
                          final pdfId = uploadData['subjectId'] ?? '';

                          return _buildPdfCard(
                            name: pdfName,
                            pdfUrl: pdfUrl,
                            pdfId: pdfId,
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      // Bottom Sheet for displaying selected quiz
      bottomSheet: _selectedQuizData != null
          ? FutureBuilder<DocumentSnapshot>(
              future: _selectedQuizData,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text(': ${snapshot.error}'));
                }
                if (!snapshot.hasData || !snapshot.data!.exists) {
                  return const Center(
                      child: Text('Hindi nahanap ang pagsusulit.'));
                }

                final quizData = snapshot.data!;
                final data = quizData.data() as Map<String, dynamic>?;
                final questions = List.from(data?['questions'] ?? []);
                if (questions.isEmpty) {
                  return const Center(
                      child: Text('Walang available na katanungan.'));
                }

                return _buildQuestionView(questions);
              },
            )
          : const SizedBox.shrink(),
    );
  }

  // Method to build the PDF card widget
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

  List<Widget> _buildOptions(Map<String, String> options) {
    return options.entries.map<Widget>((MapEntry<String, String> entry) {
      return Card(
        margin: const EdgeInsets.symmetric(vertical: 4.0),
        elevation: 2.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: ListTile(
          title: Text(entry.value),
          leading: Radio<String>(
            value: entry.key,
            groupValue: _userAnswers[_currentQuestionIndex],
            onChanged: (String? newValue) {
              setState(() {
                _userAnswers[_currentQuestionIndex] = newValue;
              });
            },
          ),
        ),
      );
    }).toList();
  }

  void _submitQuiz(List<dynamic> questions) async {
    final answers = _userAnswers.map((index, answer) {
      return MapEntry(
        questions[index]['question'],
        answer,
      );
    });

    try {
      int score = 0;
      final correctAnswers =
          questions.map((question) => question['correctAnswer']).toList();

      // Calculate score
      for (int i = 0; i < questions.length; i++) {
        if (_userAnswers[i] == correctAnswers[i]) {
          score++;
        }
      }

      // Fetch the subject name using subjectId
      String subjectName = await _getSubjectName(widget.quizTitle);

      // Store the answers and score in Firestore under 'student_answers' collection
      await FirebaseFirestore.instance.collection('student_answers').add({
        'studentId': widget.studentId,
        'quizTitle': subjectName, // Store the subject name
        'answers': answers,
        'score': score, // Store the score
        'timestamp':
            FieldValue.serverTimestamp(), // Automatically set the timestamp
      });

      _showScoreDialog(score, questions.length);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Hindi tagumpay sa pagsusumite ng pagsusulit: $e')),
      );
    }
  }

// Fetch subject name using the subjectId (quizTitle in this case)
  Future<String> _getSubjectName(String subjectId) async {
    try {
      final subjectSnapshot = await FirebaseFirestore.instance
          .collection('subjects')
          .doc(subjectId) // Using the subjectId to fetch the subject document
          .get();

      if (subjectSnapshot.exists) {
        return subjectSnapshot['subject']; // Return the subject name
      } else {
        throw Exception('Subject not found');
      }
    } catch (e) {
      print('Error fetching subject name: $e');
      return 'Unknown Subject'; // Return a default value if the subject is not found
    }
  }

  void _showScoreDialog(int score, int totalQuestions) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Pagsusulit Tapos Na!'),
          content:
              Text('Nakakuha ka ng ($score) sa ($totalQuestions) na tanong.'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  _selectedQuizData = null;
                  _currentQuestionIndex = 0;
                });
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildQuestionView(List<dynamic> questions) {
    final currentQuestion = questions[_currentQuestionIndex];
    final questionText = currentQuestion['question'] ?? 'No question available';
    final options = Map<String, String>.from(currentQuestion['options'] ?? {});

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Question ${_currentQuestionIndex + 1}/${questions.length}',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 16),
          Text(
            questionText,
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 16),
          ..._buildOptions(options),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              if (_currentQuestionIndex < questions.length - 1) {
                setState(() {
                  _currentQuestionIndex++;
                });
              } else {
                _submitQuiz(questions);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              padding:
                  const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
            ),
            child: Text(
              _currentQuestionIndex < questions.length - 1
                  ? 'Susunod'
                  : 'Isumite',
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
