import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CreateActivityPage extends StatefulWidget {
  final Function(Map<String, dynamic>) onCreated;
  final String title;
  final String subjectId; // For creating new activities
  final Map<String, dynamic>? quizData; // For editing existing activities

  const CreateActivityPage({
    super.key,
    required this.onCreated,
    required this.title,
    required this.subjectId,
    this.quizData, // Optional for editing
  });

  @override
  _CreateActivityPageState createState() => _CreateActivityPageState();
}

class _CreateActivityPageState extends State<CreateActivityPage> {
  final TextEditingController _nameController = TextEditingController();
  late List<Map<String, dynamic>> _questions;

  @override
  void initState() {
    super.initState();

    if (widget.quizData != null) {
      // If editing, pre-fill fields with existing data
      _nameController.text = widget.quizData!['title'];
      _questions = List<Map<String, dynamic>>.from(
        widget.quizData!['questions'].map((question) {
          return {
            'questionController':
                TextEditingController(text: question['question']),
            'option1Controller':
                TextEditingController(text: question['options']['Option 1']),
            'option2Controller':
                TextEditingController(text: question['options']['Option 2']),
            'option3Controller':
                TextEditingController(text: question['options']['Option 3']),
            'option4Controller':
                TextEditingController(text: question['options']['Option 4']),
            'correctAnswer': question['correctAnswer'],
          };
        }),
      );
    } else {
      // Default for new activities
      _questions = [
        {
          'questionController': TextEditingController(),
          'option1Controller': TextEditingController(),
          'option2Controller': TextEditingController(),
          'option3Controller': TextEditingController(),
          'option4Controller': TextEditingController(),
          'correctAnswer': 'Option 1', // Default
        }
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Activity Name
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Pangalan ng Gawain',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // List of Questions and Options
              ..._questions.map((questionData) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: questionData['questionController'],
                        decoration: const InputDecoration(
                          labelText: 'Ipasok ang Tanong',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildOptionField(
                          questionData['option1Controller'], 'Option 1'),
                      _buildOptionField(
                          questionData['option2Controller'], 'Option 2'),
                      _buildOptionField(
                          questionData['option3Controller'], 'Option 3'),
                      _buildOptionField(
                          questionData['option4Controller'], 'Option 4'),
                      const SizedBox(height: 16),
                      _buildCorrectAnswerDropdown(questionData),
                    ],
                  ),
                );
              }).toList(),

              // Add More Button
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _questions.add({
                      'questionController': TextEditingController(),
                      'option1Controller': TextEditingController(),
                      'option2Controller': TextEditingController(),
                      'option3Controller': TextEditingController(),
                      'option4Controller': TextEditingController(),
                      'correctAnswer': 'Option 1',
                    });
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Magdagdag pa'),
              ),
              const SizedBox(height: 16),

              // Save Button
              ElevatedButton(
                onPressed: () async {
                  final String name = _nameController.text;

                  // Validate if the activity name is empty
                  if (name.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Pakilagay ang pangalan ng gawain')),
                    );
                    return;
                  }

                  List<Map<String, dynamic>> questionsData = [];

                  // Validate each question and its options
                  for (var questionData in _questions) {
                    final question = questionData['questionController'].text;
                    final option1 = questionData['option1Controller'].text;
                    final option2 = questionData['option2Controller'].text;
                    final option3 = questionData['option3Controller'].text;
                    final option4 = questionData['option4Controller'].text;
                    final correctAnswer = questionData['correctAnswer'];

                    if (question.isEmpty ||
                        option1.isEmpty ||
                        option2.isEmpty ||
                        option3.isEmpty ||
                        option4.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              'Mangyaring punan ang lahat ng mga patlang para sa bawat tanong'),
                        ),
                      );
                      return;
                    }

                    questionsData.add({
                      'question': question,
                      'options': {
                        'Option 1': option1,
                        'Option 2': option2,
                        'Option 3': option3,
                        'Option 4': option4,
                      },
                      'correctAnswer': correctAnswer,
                    });
                  }

                  // Prepare the quiz data
                  final quizData = {
                    'title': name,
                    'subjectId': widget.subjectId,
                    'questions': questionsData,
                    'dateCreated': FieldValue.serverTimestamp(),
                  };

                  try {
                    if (widget.quizData != null) {
                      // Update existing quiz
                      final docId = widget.quizData!['id'];
                      await FirebaseFirestore.instance
                          .collection('quizzes')
                          .doc(docId)
                          .update(quizData);
                    } else {
                      // Create new quiz
                      await FirebaseFirestore.instance
                          .collection('quizzes')
                          .add(quizData);
                    }

                    widget.onCreated(quizData);

                    // Show success dialog
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Tagumpay'),
                          content:
                              const Text('Matagumpay na nagawa ang gawain!'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.pop(context);
                              },
                              child: const Text('Tapos na'),
                            ),
                          ],
                        );
                      },
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Error sa paggawa ng gawain: $e')));
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
                child: const Text('I-save ang Gawain'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to build option fields
  Widget _buildOptionField(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    );
  }

  // Helper method to build correct answer dropdown
  Widget _buildCorrectAnswerDropdown(Map<String, dynamic> questionData) {
    return DropdownButtonFormField<String>(
      value: questionData['correctAnswer'],
      onChanged: (String? newValue) {
        setState(() {
          questionData['correctAnswer'] = newValue!;
        });
      },
      decoration: const InputDecoration(
        labelText: 'Tamang Sagot',
        border: OutlineInputBorder(),
      ),
      items: ['Option 1', 'Option 2', 'Option 3', 'Option 4']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
