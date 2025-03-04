import 'package:flutter/material.dart';
import '../home/home_student.dart';
import 'sign_in.dart';
import 'sign_up.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size; // Get the screen size

    return Scaffold(
      backgroundColor: Colors.blue, // Set the background color to blue
      body: SingleChildScrollView(
        // Add a scrollable container
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 50), // Add some top padding for spacing
              // Overlay the logo at the top center
              Image.asset(
                'assets/images/icon.png', // Update with your logo image path
                width: 149,
                height: 48,
              ),
              const Text(
                'OrtoTech',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(
                  height: 5), // Spacing between logo and illustration
              // Center the Hello Illustration fitted to the width
              SizedBox(
                width: screenSize.width, // Full width of the screen
                child: Image.asset(
                  'assets/images/Hello Illustraton.png', // Update with your illustration image path
                  fit: BoxFit.fitWidth, // Fit the illustration to the width
                ),
              ),
              const SizedBox(height: 30),
              // Buttons with increased size
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Navigate to the SignInScreen when "Pumasok" is pressed
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignInScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 20), // Bigger padding for a larger button
                      textStyle:
                          const TextStyle(fontSize: 18), // Larger font size
                      minimumSize:
                          const Size(150, 60), // Minimum size for button
                    ),
                    child: const Text('Pumasok',
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'SuperCreamy',
                            fontWeight: FontWeight.w400,
                            fontSize: 20)),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: () {
                      // Navigate to the SignUpScreen when "Sumali" is pressed
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignUpScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 20), // Bigger padding for a larger button
                      textStyle:
                          const TextStyle(fontSize: 18), // Larger font size
                      minimumSize:
                          const Size(150, 60), // Minimum size for button
                    ),
                    child: const Text('Sumali',
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'SuperCreamy',
                            fontWeight: FontWeight.w400,
                            fontSize: 20)),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Simulan ang Pagkatuto button with increased size
              ElevatedButton(
                onPressed: () {
                  // Navigate to HomeStudent when "Simulan ang Pagkatuto" is pressed
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HomeStudent(
                        firstName: 'Mag-aaral', // Example data
                        studentEmail: 'student@email.com', // Example data
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 20), // Bigger padding for a larger button
                  textStyle: const TextStyle(fontSize: 18), // Larger font size
                  minimumSize: const Size(180, 60), // Minimum size for button
                ),
                child: const Text('Simulan ang Pagkatuto',
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'SuperCreamy',
                        fontWeight: FontWeight.w400,
                        fontSize: 20)),
              ),
              const SizedBox(height: 50), // Add some bottom padding for spacing
            ],
          ),
        ),
      ),
    );
  }
}
