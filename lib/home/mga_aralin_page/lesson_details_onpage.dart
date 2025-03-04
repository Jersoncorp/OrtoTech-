import 'package:flutter/material.dart';
import 'lesson_question.dart'; // Import the LessonQuestion page

class LessonDetailsOnPage extends StatelessWidget {
  const LessonDetailsOnPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.black,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Progress bar section with blue background
            Container(
              color: Colors
                  .blue[50], // Light blue background for the progress section
              padding: const EdgeInsets.all(16.0),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ProgressItem(step: "1", label: "Suriin"),
                  ProgressItem(step: "2", label: "Mga Aralin"),
                  ProgressItem(step: "3", label: "Mga Resulta"),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Lesson Title
            const Text(
              "Suriin",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              "Pangalan: Gawain Bilang 1",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // Lesson items with images instead of checkboxes
            Material(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(10),
              child: const Column(
                children: [
                  LessonItem(
                      iconPath: 'assets/images/Book.png',
                      text: "10 Katunugan (Maramihang Pamimilinan)"),
                  LessonItem(
                      iconPath: 'assets/images/Clock.png', text: "1 oras"),
                  LessonItem(
                      iconPath: 'assets/images/Certificate.png',
                      text: "Pagsusulit"),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Lesson details (Category, Subject, Teacher)
            const Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Kategorya",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text("KASONG KAMBAL-PATINIG"),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Asignatura",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text("Filipino 102"),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Guro",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text("April Rojo"),
                    ],
                  ),
                ),
              ],
            ),

            // Description Section
            const SizedBox(height: 30), // Increased space
            const Text(
              "Description",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              "Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum.",
              style: TextStyle(fontSize: 14),
            ),

            // Continue Button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to LessonQuestion page
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LessonQuestion()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  side: const BorderSide(color: Colors.black, width: 1),
                ),
                child: const Text(
                  "Magpatuloy",
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Custom Widget for Progress Item
class ProgressItem extends StatelessWidget {
  final String step;
  final String label;

  const ProgressItem({super.key, required this.step, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: step == "3" ? Colors.black12 : Colors.black,
          child: Text(
            step,
            style: TextStyle(color: step == "3" ? Colors.black : Colors.white),
          ),
        ),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}

// Custom Widget for Lesson Item
class LessonItem extends StatelessWidget {
  final String iconPath;
  final String text;

  const LessonItem({super.key, required this.iconPath, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        children: [
          Image.asset(iconPath, width: 24, height: 24),
          const SizedBox(width: 8),
          Text(text),
        ],
      ),
    );
  }
}
