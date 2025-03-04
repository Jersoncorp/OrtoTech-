import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../login/welcome_page.dart';
import 'home teacher/account_setting.dart';
import 'home teacher/classroom_page.dart';

class HomeTeacher extends StatefulWidget {
  final String teacherEmail; // Email of the teacher
  final String firstName; // First name of the teacher

  const HomeTeacher(
      {super.key, required this.firstName, required this.teacherEmail});

  @override
  _HomeTeacherState createState() => _HomeTeacherState();
}

class _HomeTeacherState extends State<HomeTeacher> {
  String? teacherName; // Teacher's name
  String? teacherEmail; // Teacher's email
  bool _isLoading = true; // Loading state

  @override
  void initState() {
    super.initState();
    _fetchTeacherData(); // Fetch teacher's data from Firestore
  }

  // Function to fetch teacher's data from Firestore
  Future<void> _fetchTeacherData() async {
    try {
      // Fetch teacher document from Firestore using teacherEmail
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget
              .teacherEmail) // Ensure Firestore uses email or another field
          .get();

      if (!doc.exists) {
        // If document does not exist, throw an error
        throw Exception(
            "Teacher data not found in Firestore for email: ${widget.teacherEmail}");
      }

      // Extract data from Firestore document
      var data = doc.data() as Map<String, dynamic>;

      setState(() {
        teacherName = data['name'] ?? 'No name found';
        teacherEmail = data['email'] ?? 'No email found';
        _isLoading = false; // Data fetched, stop loading
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      // Handle error gracefully (don't show a dialog or crash)
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      // Show a loading indicator while fetching data
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // Render teacher's home page once data is fetched
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
            "Pagbati, Guro ${widget.firstName}"), // Use firstName from widget
        backgroundColor: Colors.white,
        elevation: 0,
        titleTextStyle: const TextStyle(
          color: Colors.black,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Wala pang bagong abiso.')),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // Background illustration
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Image.asset(
              'assets/images/Start Illustration.png',
              fit: BoxFit.cover,
              width: screenSize.width,
              height: screenSize.height * 0.7,
            ),
          ),
          // Overlay logo and text
          Positioned(
            top: 16,
            left: (screenSize.width - 149) / 2,
            child: Column(
              children: [
                Image.asset(
                  'assets/images/icon.png',
                  width: 149,
                  height: 65,
                ),
                const SizedBox(height: 8), // Space between image and text
                const Text(
                  'OrtoTech',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
          // Buttons Section
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: Column(
              children: [
                buildButton(
                  context,
                  'Aking Klasrum',
                  'assets/images/Practice Button (4).png',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ClassroomPage()),
                  ),
                ),
                buildButton(
                  context,
                  'Mga Setting Sa Account',
                  'assets/images/Practice Button (2).png',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const TeacherAccountSettingsPage(),
                      ),
                    );
                  },
                ),
                buildButton(
                  context,
                  'Mag-logout',
                  'assets/images/Practice Button (3).png',
                  onTap: () => _confirmLogout(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper function to build buttons
  Widget buildButton(BuildContext context, String text, String imagePath,
      {required VoidCallback onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: GestureDetector(
        onTap: onTap,
        child: Image.asset(
          imagePath,
          width: double.infinity,
          height: 50,
        ),
      ),
    );
  }

  // Logout confirmation dialog
  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Mag-logout'),
          content: const Text('Sigurado ka bang nais mong mag-logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Bumalik'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const WelcomeScreen()),
                  (Route<dynamic> route) => false,
                );
              },
              child: const Text('Oo, Mag-logout'),
            ),
          ],
        );
      },
    );
  }
}
