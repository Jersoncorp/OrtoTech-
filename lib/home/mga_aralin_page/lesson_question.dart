import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'mga_aralin_page.dart';

class Question {
  final String text;
  final List<String> options;
  final String correctAnswer;
  final String explanation;

  Question({
    required this.text,
    required this.options,
    required this.correctAnswer,
    required this.explanation,
  });
}

class LessonQuestion extends StatefulWidget {
  const LessonQuestion({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LessonQuestionState createState() => _LessonQuestionState();
}

class _LessonQuestionState extends State<LessonQuestion> {
  final List<Question> questions = [
    Question(
      text:
          "Alin sa mga sumusunod na titik ang nagdudulot ng problema sa paghiram ng mga salita dahil sa dalawang magkaibang paraan ng pagbikas nito?",
      options: ['Ñ', 'C', 'Q', 'X'],
      correctAnswer: 'Ñ',
      explanation:
          "Ang titik C ay nagdudulot ng problema dahil mayroon itong dalawang magkaibang pagbikas na maaaring katanawin ng K o S.",
    ),
    Question(
      text:
          "Ano ang tawag sa proseso ng pagbuo ng bagong salita mula sa mga existing na salita?",
      options: ['Pagbabaybay', 'Pagbubuo', 'Pagsasalin', 'Pag-uwi'],
      correctAnswer: 'Pagbubuo',
      explanation:
          "Ang pagbubuo ay ang proseso ng paglikha ng bagong salita mula sa mga umiiral na salita.",
    ),
    Question(
      text: "Anong bahagi ng pananalita ang ginagamit upang makabuo ng tanong?",
      options: ['Pang-uri', 'Pang-abay', 'Pangngalan', 'Pangungusap'],
      correctAnswer: 'Pangungusap',
      explanation:
          "Ang pangungusap ang bahagi ng pananalita na ginagamit upang makabuo ng tanong.",
    ),
    Question(
      text: "Alin ang tamang baybay ng salitang 'kabilang'?",
      options: ['Kabilang', 'Kabilan', 'Kabilang', 'Kabilang'],
      correctAnswer: 'Kabilang',
      explanation: "Ang tamang baybay ng salitang 'kabilang' ay Kabilang.",
    ),
    Question(
      text:
          "Ano ang tawag sa mga salitang magkaiba ang kahulugan ngunit magkapareho ng baybay?",
      options: ['Homonimo', 'Antonym', 'Sinonimo', 'Kasingkahulugan'],
      correctAnswer: 'Homonimo',
      explanation:
          "Ang mga salitang magkaiba ang kahulugan ngunit magkapareho ng baybay ay tinatawag na homonimo.",
    ),
    Question(
      text: "Anong salita ang kabaligtaran ng 'mabilis'?",
      options: ['Matagal', 'Mabagal', 'Mahina', 'Matagal'],
      correctAnswer: 'Mabagal',
      explanation: "Ang kabaligtaran ng 'mabilis' ay 'mabagal'.",
    ),
    Question(
      text: "Ano ang pangunahing layunin ng pagbabasa?",
      options: [
        'Pagkuha ng impormasyon',
        'Pagpapalawak ng kaalaman',
        'Pagsusulat',
        'Pakikipag-usap'
      ],
      correctAnswer: 'Pagkuha ng impormasyon',
      explanation:
          "Ang pangunahing layunin ng pagbabasa ay ang pagkuha ng impormasyon.",
    ),
    Question(
      text: "Anong bahagi ng pangungusap ang nagsasaad ng simuno?",
      options: ['Panaguri', 'Sangkatauhan', 'Kaganapan', 'Paksa'],
      correctAnswer: 'Paksa',
      explanation:
          "Ang bahagi ng pangungusap na nagsasaad ng simuno ay tinatawag na paksa.",
    ),
    Question(
      text: "Anong tawag sa mga salitang naglalarawan sa kilos o galaw?",
      options: ['Pang-uri', 'Pang-abay', 'Pangngalan', 'Pandiwa'],
      correctAnswer: 'Pandiwa',
      explanation:
          "Ang mga salitang naglalarawan sa kilos o galaw ay tinatawag na pandiwa.",
    ),
    Question(
      text:
          "Alin sa mga sumusunod na salita ang may kasingkahulugan sa 'mahirap'?",
      options: ['Magaan', 'Mabigat', 'Malubha', 'Mahirap'],
      correctAnswer: 'Mahirap',
      explanation:
          "Ang salitang 'mahirap' ay walang kasingkahulugan sa mga ibinigay na opsyon.",
    ),
  ];

  int currentQuestionIndex = 0;
  int correctAnswers = 0;

  void _nextQuestion(String selectedAnswer) {
    // Check if the selected answer is correct
    if (selectedAnswer == questions[currentQuestionIndex].correctAnswer) {
      correctAnswers++;
      // Show explanation dialog for correct answer
      _showExplanationDialog(questions[currentQuestionIndex].explanation,
          questions[currentQuestionIndex].correctAnswer, true);
    } else {
      // Show explanation dialog for incorrect answer
      _showExplanationDialog(questions[currentQuestionIndex].explanation,
          questions[currentQuestionIndex].correctAnswer, false);
    }
  }

  // Method to show explanation dialog
  void _showExplanationDialog(
      String explanation, String correctAnswer, bool isCorrect) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            isCorrect
                ? "Ang Tamang Sagot ay $correctAnswer"
                : "Maling Sagot: $correctAnswer",
            style: TextStyle(
              color: isCorrect
                  ? Colors.green
                  : Colors.red, // Green for correct, Red for incorrect
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Tandaan:",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  explanation,
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                setState(() {
                  if (currentQuestionIndex < questions.length - 1) {
                    currentQuestionIndex++;
                  } else {
                    // Navigate to results page
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ResultPage(
                          score: correctAnswers,
                          totalQuestions: questions.length,
                        ),
                      ),
                    );
                  }
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: isCorrect
                    ? Colors.green
                    : Colors.red, // Button color based on correctness
              ),
              child: const Text("Magpatuloy"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final question = questions[currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Lesson Questions"),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.black,
          onPressed: () {
            Navigator.pop(context); // Go back to the previous screen
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Progress Bar
            LinearProgressIndicator(
              value: (currentQuestionIndex + 1) / questions.length,
              backgroundColor: Colors.grey[300],
              color: Colors.blue,
            ),
            const SizedBox(height: 16),

            // Question Text
            Text(
              question.text,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Answer Options
            for (var option in question.options)
              AnswerOption(
                text: option,
                onPressed: () {
                  _nextQuestion(option); // Pass the selected answer
                },
              ),
          ],
        ),
      ),
    );
  }
}

// Widget for Answer Options
class AnswerOption extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const AnswerOption({required this.text, required this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                backgroundColor: Colors.blue[100], // Light blue background
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                text,
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Result Page to show the score
class ResultPage extends StatelessWidget {
  final int score;
  final int totalQuestions;

  const ResultPage({
    required this.score,
    required this.totalQuestions,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = (score / totalQuestions) * 100;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Result"),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.black,
          onPressed: () {
            Navigator.pop(context); // Go back to the previous screen
          },
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularPercentIndicator(
                radius: 100.0,
                lineWidth: 13.0,
                animation: true,
                percent: percentage / 100,
                center: Text(
                  "${percentage.toStringAsFixed(0)}%",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 20.0),
                ),
                backgroundColor: Colors.grey[300]!,
                progressColor: Colors.blue,
              ),
              const SizedBox(height: 16),
              const Text(
                "Mahusay!",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Text(
                "$score na tamang sagot sa $totalQuestions na katanungan",
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Navigate to the Mga Aralin page and remove all previous pages from the stack
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MgaAralinPage(
                        studentEmail: '',
                      ),
                    ),
                    (Route<dynamic> route) =>
                        false, // Remove all previous routes
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                ),
                child: const Text("Tapos na"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
