import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:social_media_app/models/post_model.dart';
import 'package:social_media_app/services/post_services.dart';
import 'package:social_media_app/widgets/comments_bottom_sheet.dart';
import 'package:social_media_app/widgets/liked_by_bottom_sheet.dart';
import 'package:social_media_app/screens/edit_post_screen.dart';

class PostDetailsScreen extends StatelessWidget {
  final Post post;

  const PostDetailsScreen({
    super.key,
    required this.post,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post'),
        centerTitle: true,
      ),

      body: SafeArea(
        child: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('posts')
              .doc(post.postId)
              .snapshots(),

          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (!snapshot.hasData || !snapshot.data!.exists) {
              return const Center(
                child: Text('Post not found.'),
              );
            }

            final data = snapshot.data!.data() as Map<String, dynamic>;

            // ---------------- Likes / Comments data ----------------

            final likesCount = data['likesCount'] ?? 0;

            final commentsCount = data['commentsCount'] ?? 0;

            final likedBy = List<String>.from(data['likedBy'] ?? []);

            final currentUser = FirebaseAuth.instance.currentUser;

            final isLiked =
                currentUser != null && likedBy.contains(currentUser.uid);

            return SingleChildScrollView(
              padding: const EdgeInsets.all(15),

              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      // ---------------- User ----------------
                      StreamBuilder<DocumentSnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('users')
                            .doc(post.userId)
                            .snapshots(),

                        builder: (context, snapshot) {
                          String profileImage = '';

                          if (snapshot.hasData && snapshot.data!.exists) {
                            final userData =
                                snapshot.data!.data() as Map<String, dynamic>;

                            profileImage = userData['profileImage'] ?? '';
                          }

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

                              if (post.userId ==
                                  FirebaseAuth.instance.currentUser!.uid)
                                IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => EditPostScreen(
                                          post: post,
                                        ),
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.more_vert),
                                ),
                            ],
                          );
                        },
                      ),

                      const SizedBox(height: 20),

                      // ---------------- Title ----------------
                      Text(
                        post.title,

                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 15),

                      // ---------------- Image ----------------
                      if (post.imageUrl.isNotEmpty) ...[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),

                          child: Image.network(
                            post.imageUrl,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),

                        const SizedBox(height: 15),
                      ],

                      // ---------------- Description ----------------
                      Text(
                        post.description,

                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),

                      const SizedBox(height: 16),

                      // ---------------- Likes / Comments ----------------
                      Row(
                        children: [
                          // ---------------- Like ----------------
                          GestureDetector(
                            onLongPress: () {
                              showModalBottomSheet(
                                context: context,

                                builder: (_) {
                                  return LikedByBottomSheet(
                                    userIds: likedBy,
                                  );
                                },
                              );
                            },

                            child: IconButton(
                              onPressed: currentUser == null
                                  ? null
                                  : () async {
                                      await PostServices.likePost(
                                        post.postId,
                                      );
                                    },

                              icon: Icon(
                                isLiked
                                    ? Icons.favorite
                                    : Icons.favorite_border,

                                color: isLiked ? Colors.red : null,
                              ),
                            ),
                          ),

                          Text(
                            '$likesCount',
                          ),

                          const SizedBox(width: 20),

                          // ---------------- Comments ----------------
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

                          Text(
                            '$commentsCount',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
