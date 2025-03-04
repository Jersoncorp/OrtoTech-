import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../home/home_student.dart'; // Student home page

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isPasswordVisible = false;
  bool _isSigningUp = false;
  String? _errorMessage;

  Future<void> _signUp() async {
    setState(() {
      _isSigningUp = true;
      _errorMessage = null;
    });

    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    try {
      // Check if the email is already in use
      final existingUser = await _auth.fetchSignInMethodsForEmail(email);
      if (existingUser.isNotEmpty) {
        setState(() {
          _errorMessage = 'This email is already registered.';
        });
        return;
      }

      // Create Firebase Authentication account for the student
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await userCredential.user?.updateDisplayName(name);

      // Get the user's UID (unique identifier)
      String studentId =
          userCredential.user?.uid ?? ''; // Using UID as studentId

      // Save student data in Firestore (only in the 'student_users' collection)
      await _firestore
          .collection('student_users')
          .doc(userCredential.user?.uid ?? studentId)
          .set({
        'studentId': studentId, // Add studentId to Firestore document
        'name': name,
        'email': email,
        'bio': 'Empty bio..',
      });

      // Navigate to the HomeStudent page after successful sign-up
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => HomeStudent(
            firstName: name,
            studentEmail:
                email, // Pass the student's email to the HomeStudent page
          ),
        ),
        (Route<dynamic> route) => false, // Remove all previous routes
      );
    } catch (e) {
      setState(() {
        _errorMessage = 'Error: $e';
      });
    } finally {
      setState(() {
        _isSigningUp = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50], // Lighter background for a modern feel
      appBar: AppBar(
        title: const Text("Mag-sign Up"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(32.0), // More padding for better spacing
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Display error message if any
            if (_errorMessage != null)
              Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
            const SizedBox(height: 40), // Increase space before text fields

            // Name TextField with better styling
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Ilagay ang iyong Pangalan',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.blueAccent, width: 1),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
              ),
            ),
            const SizedBox(height: 20),

            // Email TextField with better styling
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Ilagay ang iyong Email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.blueAccent, width: 1),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
              ),
            ),
            const SizedBox(height: 20),

            // Password TextField with visibility toggle
            TextField(
              controller: passwordController,
              obscureText: !isPasswordVisible,
              decoration: InputDecoration(
                labelText: 'Ilagay ang iyong Password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.blueAccent, width: 1),
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    color: Colors.blueAccent,
                  ),
                  onPressed: () {
                    setState(() {
                      isPasswordVisible = !isPasswordVisible;
                    });
                  },
                ),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
              ),
            ),
            const SizedBox(height: 30), // More space before button

            // SignUp Button with loading indicator
            ElevatedButton(
              onPressed: _isSigningUp ? null : _signUp,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent, // Button color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: _isSigningUp
                  ? const CircularProgressIndicator(
                      color: Colors.white,
                    )
                  : const Text(
                      'Mag-sign Up',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white, // White text color
                      ),
                    ),
            ),
            const SizedBox(height: 20),

            // Login navigation with a cleaner style
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  'May Account na? Mag-log in',
                  style: TextStyle(color: Colors.blueAccent),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
