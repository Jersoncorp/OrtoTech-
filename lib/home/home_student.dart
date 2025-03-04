import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../login/welcome_page.dart';
import 'acc_setting_page.dart';
import 'mga_aralin_page/mga_aralin_page.dart';
import 'suriin_page/suriin_page.dart';

class HomeStudent extends StatelessWidget {
  final String firstName; // First name of the student
  final String studentEmail; // Email of the student

  const HomeStudent({
    super.key,
    required this.firstName,
    required this.studentEmail,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text("Pagbati, $firstName!"),
        backgroundColor: Colors.blue,
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

          // Buttons below the illustration
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: Column(
              children: [
                buildButton(context, 'Suriin',
                    'assets/images/Practice Button.png', screenSize, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SuriinPage()),
                  );
                }),
                buildButton(context, 'Mga Aralin',
                    'assets/images/Practice Button (1).png', screenSize, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MgaAralinPage(
                        studentEmail: studentEmail,
                      ),
                    ),
                  );
                }),
                buildButton(
                  context,
                  'Mga Setting ng Account',
                  'assets/images/Practice Button (2).png',
                  screenSize,
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AccountSettingsPage(),
                      ),
                    );
                  },
                ),
                buildButton(context, 'Mag-logout',
                    'assets/images/Practice Button (3).png', screenSize, () {
                  _confirmLogout(context);
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildButton(BuildContext context, String text, String imagePath,
      Size screenSize, VoidCallback onTap) {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        double scaleFactor = 1.0;

        return GestureDetector(
          onTapDown: (_) {
            setState(() {
              scaleFactor = 0.9; // Scale down on press
            });
          },
          onTapUp: (_) {
            setState(() {
              scaleFactor = 1.0; // Restore scale
            });
          },
          onTapCancel: () {
            setState(() {
              scaleFactor = 1.0; // Reset scale on cancel
            });
          },
          onTap: onTap,
          child: Transform.scale(
            scale: scaleFactor,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Image.asset(
                imagePath,
                width: screenSize.width * 0.8, // Adjust for responsiveness
                height: 50,
              ),
            ),
          ),
        );
      },
    );
  }

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Mag-logout'),
          content: const Text('Sigurado ka bang nais mong mag-logout?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Bumalik'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(); // Close the dialog
                await _logout(context);
              },
              child: const Text('Oo, Mag-logout'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _logout(BuildContext context) async {
    try {
      // Firebase sign out
      await FirebaseAuth.instance.signOut();

      // Navigate to the Welcome Screen after logout
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const WelcomeScreen(),
        ),
        (Route<dynamic> route) => false, // Remove all previous routes
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error during logout: $e')),
      );
    }
  }
}
