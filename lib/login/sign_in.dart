import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../home/home_student.dart';
import '../home/home_teacher_page.dart';
import '../login/forgot_password.dart';
import 'sign_up.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isPasswordVisible = false;
  bool _isSigningIn = false;
  String? _errorMessage;

  Future<void> _signIn() async {
    setState(() {
      _isSigningIn = true;
      _errorMessage = null;
    });

    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    try {
      // Sign in the user with email and password
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      // Fetch user data from Firestore (check both collections)
      final userDoc = await _firestore
          .collection('users')
          .doc(userCredential.user?.uid)
          .get();
      final studentDoc = await _firestore
          .collection('student_users')
          .doc(userCredential.user?.uid)
          .get();

      if (userDoc.exists) {
        // User found in 'users' collection (Teacher)
        final name = userDoc['name'];
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => HomeTeacher(
              firstName: name,
              teacherEmail: email, // Pass the UID from Firebase Auth
            ),
          ),
          (Route<dynamic> route) => false, // Remove all previous routes
        );
      } else if (studentDoc.exists) {
        // User found in 'student_users' collection (Student)
        final name = studentDoc['name'];
        final studentEmail = studentDoc['email'];
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => HomeStudent(
              firstName: name,
              studentEmail: studentEmail,
            ),
          ),
          (Route<dynamic> route) => false, // Remove all previous routes
        );
      } else {
        // No user found in either collection
        setState(() {
          _errorMessage = 'Walang account na natagpuan sa mga koleksyon.';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage =
            'Error: $e'; // Show error message in Filipino if possible
      });

      // Show a dialog if the error is due to incorrect email/password
      if (e.toString().contains('wrong-password') ||
          e.toString().contains('user-not-found')) {
        _showErrorDialog(
            'Mali ang email o password na inilagay. Pakisubukang muli.');
      }
    } finally {
      setState(() {
        _isSigningIn = false;
      });
    }
  }

  // Method to show error dialog
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Mali'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50], // Lighter background for a modern feel
      appBar: AppBar(
        title: const Text("Pumasok"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(32.0), // More padding for better spacing
        child: SingleChildScrollView(
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

              // Email TextField with better styling
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Ilagay ang iyong Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide:
                        const BorderSide(color: Colors.blueAccent, width: 1),
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
                    borderSide:
                        const BorderSide(color: Colors.blueAccent, width: 1),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
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

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return const ForgotPasswordPage();
                            },
                          ) as Route<Object?>,
                        );
                      },
                      child: const Text(
                        'Nakalimutan ang Password?',
                        style: TextStyle(
                            color: Colors.blueAccent,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30), // More space before button

              // SignIn Button with loading indicator
              ElevatedButton(
                onPressed: _isSigningIn ? null : _signIn,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent, // Button color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: _isSigningIn
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : const Text(
                        'Pumasok',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white, // White text color
                        ),
                      ),
              ),
              const SizedBox(height: 20),

              // Sign up navigation with a cleaner style
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment
                        .center, // Centering the Row horizontally
                    crossAxisAlignment: CrossAxisAlignment
                        .center, // Centering the Row vertically if needed
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return const SignUpScreen();
                              },
                            ) as Route<Object?>,
                          );
                        },
                        child: const Text(
                          'Wala pang account? Sumali rito',
                          style: TextStyle(
                              color: Colors.blueAccent,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
