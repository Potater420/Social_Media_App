import 'package:flutter/material.dart';
import 'package:sprints_firstapp/screens/user_profile_screen.dart';
import 'package:sprints_firstapp/screens/create_post_screen.dart';
import 'package:sprints_firstapp/models/post_model.dart';
import 'package:sprints_firstapp/services/post_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sprints_firstapp/widgets/comments_bottom_sheet.dart';
import 'package:sprints_firstapp/widgets/liked_by_bottom_sheet.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('ConnectHub'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const UserProfileScreen(),
                ),
              );
            },
            icon: const Icon(Icons.person),
          ),
        ],
      ),

      body: StreamBuilder<List<Post>>(
        stream: PostServices.getPosts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text('Something went wrong.'),
            );
          }

          final posts = snapshot.data ?? [];

          if (posts.isEmpty) {
            return const Center(
              child: Text(
                'No posts yet.',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];

              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      StreamBuilder<DocumentSnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('users')
                            .doc(post.userId)
                            .snapshots(),
                        builder: (context, userSnapshot) {
                          if (!userSnapshot.hasData ||
                              !userSnapshot.data!.exists) {
                            return Row(
                              children: [
                                const CircleAvatar(
                                  radius: 22,
                                  child: Icon(Icons.person),
                                ),

                                const SizedBox(width: 12),

                                Text(
                                  post.username,
                                  style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            );
                          }

                          final userData =
                              userSnapshot.data!.data() as Map<String, dynamic>;

                          final profileImage = userData['profileImage'] ?? '';

                          return Row(
                            children: [
                              CircleAvatar(
                                radius: 22,
                                backgroundImage: profileImage.isNotEmpty
                                    ? NetworkImage(profileImage)
                                    : null,
                                child: profileImage.isEmpty
                                    ? const Icon(Icons.person)
                                    : null,
                              ),

                              const SizedBox(width: 12),

                              Expanded(
                                child: Text(
                                  post.username,
                                  style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          );
                        },
                      ),

                      const SizedBox(height: 18),

                      Text(
                        post.title,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        post.description,
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),

                      if (post.imageUrl.isNotEmpty) ...[
                        const SizedBox(height: 12),

                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            post.imageUrl,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],

                      const SizedBox(height: 12),

                      Row(
                        children: [
                          GestureDetector(
                            onLongPress: () {
                              showModalBottomSheet(
                                context: context,
                                builder: (_) => LikedByBottomSheet(
                                  userIds: post.likedBy,
                                ),
                              );
                            },
                            child: IconButton(
                              onPressed: () async {
                                await PostServices.likePost(post.postId);
                              },
                              icon: Icon(
                                post.likedBy.contains(
                                      FirebaseAuth.instance.currentUser!.uid,
                                    )
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color:
                                    post.likedBy.contains(
                                      FirebaseAuth.instance.currentUser!.uid,
                                    )
                                    ? Colors.red
                                    : null,
                              ),
                            ),
                          ),

                          Text('${post.likesCount}'),

                          const SizedBox(width: 20),

                          IconButton(
                            onPressed: () {
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                useSafeArea: true,
                                builder: (context) {
                                  return CommentsBottomSheet(
                                    postId: post.postId,
                                  );
                                },
                              );
                            },
                            icon: const Icon(
                              Icons.comment_outlined,
                            ),
                          ),

                          Text('${post.commentsCount}'),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const CreatePostScreen(),
            ),
          );
        },
        child: const Icon(Icons.post_add),
      ),
    );
  }
}
