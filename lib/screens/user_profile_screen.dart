import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sprints_firstapp/services/image_services.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';


class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  File? profileImage;
  Future<void> pickProfileImage() async {
    final ImagePicker picker = ImagePicker();

    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (image != null) {
      final File selectedImage = File(image.path);

      setState(() {
        profileImage = selectedImage;
      });

      final imageUrl = await ImageServices.uploadImage(
        image: selectedImage,
        apiKey: 'YOUR_API_KEY',
      );

      final String uid = FirebaseAuth.instance.currentUser!.uid;

      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'profileImage': imageUrl,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final String uid = FirebaseAuth.instance.currentUser!.uid;
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        centerTitle: true,
      ),

      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(
              child: Text('User profile not found.'),
            );
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;

          final username = data['username'] ?? 'Username';
          final email = data['email'] ?? 'Email';
          final profileImageUrl = data['profileImage'] ?? '';

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    print('Profile picture tapped');
                    pickProfileImage();
                  },
                  child: CircleAvatar(
                    radius: 60,
                    backgroundImage: profileImage != null
                        ? FileImage(profileImage!)
                        : profileImageUrl.isNotEmpty
                        ? NetworkImage(profileImageUrl)
                        : null,
                    child: profileImage == null && profileImageUrl.isEmpty
                        ? const Icon(
                            Icons.person,
                            size: 60,
                          )
                        : null,
                  ),
                ),

                const SizedBox(height: 20),

                Text(
                  username,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  email,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),

                const SizedBox(height: 30),

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

                ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text('Logout'),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                  ),
                  onTap: () {
                    // Logout later
                  },
                ),

                ListTile(
                  leading: const Icon(Icons.delete),
                  title: const Text('Delete Account'),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                  ),
                  onTap: () {
                    // Delete account later
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
