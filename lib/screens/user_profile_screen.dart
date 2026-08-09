import 'package:flutter/material.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Profile picture
            const CircleAvatar(
              radius: 60,
              child: Icon(
                Icons.person,
                size: 60,
              ),
            ),

            const SizedBox(height: 20),

            // Username
            const Text(
              'Username',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            // Email
            const Text(
              'user@email.com',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
            ),

            const SizedBox(height: 30),

            // Edit Profile
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Edit profile later
                },
                child: const Text('Edit Profile'),
              ),
            ),

            const SizedBox(height: 30),

            const Divider(),

            const SizedBox(height: 10),

            // Logout
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                // Logout later
              },
            ),

            // Delete account
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text('Delete Account'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                // Delete account later
              },
            ),
          ],
        ),
      ),
    );
  }
}