import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_media_app/models/post_model.dart';
import 'package:social_media_app/widgets/comments_bottom_sheet.dart';
import 'package:social_media_app/widgets/liked_by_bottom_sheet.dart';

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

      body: SingleChildScrollView(
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

                        Text(
                          post.username,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
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
                  const SizedBox(height: 16),

                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      post.imageUrl,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
                const SizedBox(height: 15),

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
                    // Like list ONLY
                    IconButton(
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (_) {
                            return LikedByBottomSheet(
                              userIds: post.likedBy,
                            );
                          },
                        );
                      },
                      icon: const Icon(
                        Icons.favorite_border,
                      ),
                    ),

                    Text('${post.likesCount}'),

                    const SizedBox(width: 20),

                    // Comments
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
        ),
      ),
    );
  }
}
