import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore integration
import 'package:flutter/material.dart';

class TeacherAccountSettingsPage extends StatefulWidget {
  const TeacherAccountSettingsPage({super.key});

  @override
  State<TeacherAccountSettingsPage> createState() =>
      _TeacherAccountSettingsPageState();
}

class _TeacherAccountSettingsPageState
    extends State<TeacherAccountSettingsPage> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Controller for the bio text field
  TextEditingController bioController = TextEditingController();
  bool isEditing = false; // Flag to toggle between display and edit mode
  String bio = ''; // Variable to hold bio value
  String name = ''; // Variable to hold name value (from Firestore)

  // Fetch the bio and name from Firestore in the 'users' collection
  Future<void> getUserData() async {
    try {
      var userDoc = await _firestore
          .collection(
              'users') // Use 'users' collection or whatever collection you're using
          .doc(currentUser.uid)
          .get();

      setState(() {
        bio = userDoc['bio'] ?? 'Walang pagpapakilala'; // Update bio
        bioController.text = bio; // Update the controller text
        name =
            userDoc['name'] ?? 'Walang pangalan'; // Update name from Firestore
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error sa pagkuha ng data ng user: $e')),
      );
    }
  }

  // Updating the bio in Firestore
  Future<void> updateBio() async {
    try {
      await _firestore
          .collection(
              'users') // Use 'users' collection or whatever you're using
          .doc(currentUser.uid)
          .update({
        'bio': bioController.text,
      });
      setState(() {
        isEditing = false; // Switch back to display mode
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Matagumpay na na-update ang Pagpapakilala!')),
      );
      // Re-fetch the bio after updating
      await getUserData(); // This ensures the bio is reloaded with the new value
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error sa pag-update ng Pagpapakilala: $e')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    getUserData(); // Fetch user data (name and bio) when the page loads
  }

  @override
  void dispose() {
    bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 217, 218, 216),
      appBar: AppBar(
        title: const Text('Mga Settings ng Account'),
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.black,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: ListView(
          children: [
            const SizedBox(height: 16.0), // Space to separate from the top

            // Name Display
            Text(
              name, // Display the 'name' variable fetched from Firestore
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 28.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              "(Teacher)",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: 15.0,
              ),
            ),

            const SizedBox(height: 21.0), // Space between name and email

            // Email Display
            Text(
              currentUser.email ?? 'Walang Email',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 16.0,
              ),
            ),

            const SizedBox(height: 16.0), // Space before bio section

            // Bio Section with the "Edit" link in the top-right
            Card(
              elevation: 4.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Row to display 'Bio' and the 'Edit' button beside it
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Pagpapakilala',
                          style: TextStyle(
                              fontSize: 22.0, fontWeight: FontWeight.w700),
                        ),
                        if (!isEditing)
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isEditing = true;
                              });
                            },
                            child: const Text(
                              'Baguhin',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16.0,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8.0),

                    // Bio content with conditional edit functionality
                    isEditing
                        ? TextFormField(
                            controller: bioController,
                            maxLines: 3,
                            decoration: const InputDecoration(
                              labelText: 'Nabago na ang Pagpapakilala',
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 12.0, horizontal: 16.0),
                            ),
                          )
                        : Text(
                            bio.isEmpty
                                ? 'Walang Pagpapakilala'
                                : bio, // Use the bio variable for display
                            style: const TextStyle(fontSize: 16.0),
                          ),

                    // Save the bio when editing
                    if (isEditing)
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: ElevatedButton(
                          onPressed: updateBio,
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 48),
                            backgroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text('I-save ang Pagpapakilala'),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
