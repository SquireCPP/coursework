import 'package:flutter/material.dart';
import '../database_helper.dart'; // Import the database helper

class DeleteAccountScreen extends StatelessWidget {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  DeleteAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Delete Account')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Are you sure you want to delete your account?',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                // Assume you have a way of getting the current user ID
                int userId = 1; // Example user ID. You can replace this with dynamic data.
                try {
                  // Delete the user from the database
                  await _databaseHelper.deleteUser(userId);
                  // Show success message
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Account deleted successfully.')),
                  );
                  // Navigate back to the login screen (or any other screen)
                  Navigator.pushReplacementNamed(context, '/login');
                } catch (e) {
                  // Show error message in case of failure
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error deleting account: $e')),
                  );
                }
              },
              child: const Text('Delete Account'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 40),
              ),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () {
                // Navigate back to the previous screen if the user cancels
                Navigator.pop(context);
              },
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
