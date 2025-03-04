import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For formatting timestamp
import 'package:fl_chart/fl_chart.dart';

class ReportsTab extends StatelessWidget {
  final String classTitle;
  const ReportsTab({super.key, required this.classTitle});

  // Fetching quiz attempts from Firestore based on 'student_answers' and grouped by quizTitle
  Future<Map<String, Map<String, List<Map<String, dynamic>>>>>
      getQuizAttempts() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    Map<String, Map<String, List<Map<String, dynamic>>>> quizAttemptsHistory =
        {};

    // Fetching the student answers from Firestore
    QuerySnapshot snapshot =
        await firestore.collection('student_answers').get();

    // Grouping data by quizTitle, and then by date and listing studentId and their scores
    for (var doc in snapshot.docs) {
      final data = doc.data() as Map<String, dynamic>;

      // Extracting quizTitle, studentId, timestamp, and score
      final quizTitle = data['quizTitle'] as String;
      final studentId = data['studentId'] as String;
      final timestamp = data['timestamp'] as Timestamp;
      final score = data['score'] as int;

      // Formatting the timestamp to mm/dd format
      String formattedDate = DateFormat('MM/dd').format(timestamp.toDate());

      // Adding each studentId and their score to the list for the given quizTitle and date
      quizAttemptsHistory[quizTitle] ??= {};
      quizAttemptsHistory[quizTitle]![formattedDate] ??= [];

      quizAttemptsHistory[quizTitle]![formattedDate]!.add({
        'studentId': studentId,
        'score': score,
      });
    }

    return quizAttemptsHistory;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child:
            FutureBuilder<Map<String, Map<String, List<Map<String, dynamic>>>>>(
          future: getQuizAttempts(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            final quizAttemptsHistory = snapshot.data ?? {};

            if (quizAttemptsHistory.isEmpty) {
              return const Center(
                  child: Text('Walang available na pagsubok sa pagsusulit.'));
            }

            return SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                  ),
                  // Title for Bar Chart (Student Attempts per Date)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      'Mga Pagsusubok ng Mag-aaral bawat Petsa',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: Colors.black.withOpacity(0.8),
                      ),
                    ),
                  ),
                  // Bar chart container centered
                  Center(
                    child: Container(
                      margin: const EdgeInsets.only(top: 10),
                      height: 300,
                      width: 350,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: BarChart(
                          BarChartData(
                            gridData: const FlGridData(show: true),
                            titlesData: FlTitlesData(
                              show: true,
                              leftTitles: const AxisTitles(
                                sideTitles: SideTitles(
                                    showTitles: true, reservedSize: 30),
                              ),
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget:
                                      (double value, TitleMeta meta) {
                                    final quizList =
                                        quizAttemptsHistory.keys.toList();
                                    if (value.toInt() < quizList.length) {
                                      final quizTitle = quizList[value.toInt()];
                                      return Text(
                                        quizTitle,
                                        style: const TextStyle(fontSize: 12),
                                      );
                                    }
                                    return const SizedBox();
                                  },
                                ),
                              ),
                            ),
                            borderData: FlBorderData(show: true),
                            maxY: quizAttemptsHistory.values.isNotEmpty
                                ? quizAttemptsHistory.values
                                    .map((quizData) =>
                                        quizData.values.expand((e) => e).length)
                                    .reduce((a, b) => a > b ? a : b)
                                    .toDouble()
                                : 30,
                            barGroups:
                                quizAttemptsHistory.entries.map((quizEntry) {
                              final quizTitle = quizEntry.key;
                              final attempts = quizEntry.value.values
                                  .expand((e) => e)
                                  .length;

                              return BarChartGroupData(
                                x: quizAttemptsHistory.keys
                                    .toList()
                                    .indexOf(quizTitle),
                                barRods: [
                                  BarChartRodData(
                                    fromY: 0,
                                    toY: attempts.toDouble(),
                                    color: Colors.blue,
                                    width: 8,
                                  ),
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Title for Student Attempts History
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      'Ulat ng gawain ng mga Mag-aaral',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: Colors.black.withOpacity(0.8),
                      ),
                    ),
                  ),
                  // Student attempts history container centered
                  Center(
                    child: Container(
                      margin: const EdgeInsets.only(top: 10),
                      width: 350,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: quizAttemptsHistory.keys.length,
                          itemBuilder: (context, index) {
                            final quizTitle =
                                quizAttemptsHistory.keys.toList()[index];
                            final dateStudentMap =
                                quizAttemptsHistory[quizTitle]!;

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Quiz: $quizTitle',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                ...dateStudentMap.entries.map((entry) {
                                  final date = entry.key;
                                  final students = entry.value;

                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Petsa: $date',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      ...students.map((student) {
                                        final studentId = student['studentId'];
                                        final score = student['score'];

                                        return Padding(
                                          padding:
                                              const EdgeInsets.only(left: 8.0),
                                          child: Text(
                                            '$studentId - Score: $score',
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.black87,
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                      const Divider(),
                                    ],
                                  );
                                }).toList(),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
