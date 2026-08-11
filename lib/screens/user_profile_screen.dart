import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:social_media_app/screens/welcome_screen.dart';
import 'package:social_media_app/services/image_services.dart';
import 'package:social_media_app/cubit/auth_cubit/auth_cubit.dart';
import 'package:social_media_app/cubit/auth_cubit/auth_state.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  File? profileImage;

  // ---------------- Pick Profile Picture ----------------

  Future<void> pickProfileImage() async {
    final ImagePicker picker = ImagePicker();

    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (image == null) return;

    final File selectedImage = File(image.path);

    setState(() {
      profileImage = selectedImage;
    });

    final imageUrl = await ImageServices.uploadImage(
      image: selectedImage,
      apiKey: '99fecb79a682139d934ae76e00582ea5',
    );

    if (imageUrl == 'Upload failed') {
      return;
    }

    final String uid = FirebaseAuth.instance.currentUser!.uid;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .update({
      'profileImage': imageUrl,
    });
  }

  // ---------------- Edit Username ----------------

  void editUsername(String currentUsername) {
    final controller = TextEditingController(
      text: currentUsername,
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Username'),

          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: const InputDecoration(
              labelText: 'Username',
            ),
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),

            TextButton(
              onPressed: () async {
                final newUsername = controller.text.trim();

                if (newUsername.isEmpty) {
                  return;
                }

                final uid =
                    FirebaseAuth.instance.currentUser!.uid;

                final firestore =
                    FirebaseFirestore.instance;

                // Update username in user profile
                await firestore
                    .collection('users')
                    .doc(uid)
                    .update({
                  'username': newUsername,
                });

                // Update username in user's posts
                final posts = await firestore
                    .collection('posts')
                    .where('userId', isEqualTo: uid)
                    .get();

                for (final post in posts.docs) {
                  await post.reference.update({
                    'username': newUsername,
                  });
                }

                // Update username in user's comments
                final allPosts =
                    await firestore.collection('posts').get();

                for (final post in allPosts.docs) {
                  final comments = await post.reference
                      .collection('comments')
                      .where('userId', isEqualTo: uid)
                      .get();

                  for (final comment in comments.docs) {
                    await comment.reference.update({
                      'username': newUsername,
                    });
                  }
                }

                if (context.mounted) {
                  Navigator.pop(context);
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final String uid =
        FirebaseAuth.instance.currentUser!.uid;

    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthInitial) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (_) => const WelcomePage(),
            ),
            (route) => false,
          );
        }

        if (state is AuthFailed) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                context.read<AuthCubit>().errorMessage,
              ),
            ),
          );
        }
      },

      child: Scaffold(
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
            if (snapshot.connectionState ==
                ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (!snapshot.hasData ||
                !snapshot.data!.exists) {
              return const Center(
                child: Text('User profile not found.'),
              );
            }

            final data =
                snapshot.data!.data() as Map<String, dynamic>;

            final username =
                data['username'] ?? 'Username';

            final email =
                data['email'] ?? 'Email';

            final profileImageUrl =
                data['profileImage'] ?? '';

            return SingleChildScrollView(
              padding: const EdgeInsets.all(24),

              child: Column(
                children: [

                  // ---------------- Profile Picture ----------------

                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundImage: profileImage != null
                            ? FileImage(profileImage!)
                            : profileImageUrl.isNotEmpty
                                ? NetworkImage(profileImageUrl)
                                : null,
                        child: profileImage == null &&
                                profileImageUrl.isEmpty
                            ? const Icon(
                                Icons.person,
                                size: 60,
                              )
                            : null,
                      ),

                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: pickProfileImage,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.camera_alt,
                              size: 20,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // ---------------- Username ----------------

                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.center,
                    children: [
                      Text(
                        username,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      IconButton(
                        onPressed: () {
                          editUsername(username);
                        },
                        icon: const Icon(
                          Icons.edit,
                          size: 20,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // ---------------- Email ----------------

                  Text(
                    email,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),

                  const SizedBox(height: 30),

                  const Divider(),

                  const SizedBox(height: 10),

                  // ---------------- Logout ----------------

                  ListTile(
                    leading: const Icon(Icons.logout),
                    title: const Text('Logout'),
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                    ),
                    onTap: () {
                      context
                          .read<AuthCubit>()
                          .logoutUserCubit();
                    },
                  ),

                  // ---------------- Delete Account ----------------

                  ListTile(
                    leading: const Icon(Icons.delete),
                    title: const Text('Delete Account'),
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                    ),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text(
                              'Delete Account',
                            ),
                            content: const Text(
                              'Are you sure you want to permanently delete your account?',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  context
                                      .read<AuthCubit>()
                                      .deleteUserCubit();
                                },
                                child: const Text('Delete'),
                              ),
                            ],
                          );
                        },
                      );
                    },
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