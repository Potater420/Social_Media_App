import 'package:flutter/material.dart';
import 'package:social_media_app/models/post_model.dart';
import 'package:social_media_app/services/post_services.dart';
import 'package:social_media_app/screens/post_details_screen.dart';

class MyPostsWidget extends StatelessWidget {
  final String uid;

  const MyPostsWidget({
    super.key,
    required this.uid,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Post>>(
      stream: PostServices.getPosts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final myPosts = (snapshot.data ?? [])
            .where((post) => post.userId == uid)
            .toList();

        if (myPosts.isEmpty) {
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              vertical: 20,
            ),
            child: const Text(
              'No posts yet.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white70,
              ),
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---------------- Title ----------------

            const Text(
              'My Posts',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            // ---------------- Posts ----------------

            SizedBox(
              height: 165,

              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: myPosts.length,

                itemBuilder: (context, index) {
                  final post = myPosts[index];

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PostDetailsScreen(
                            post: post,
                          ),
                        ),
                      );
                    },

                    child: Container(
                      width: 170,
                      margin: const EdgeInsets.only(
                        right: 12,
                      ),

                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .surfaceContainerHighest,

                        borderRadius: BorderRadius.circular(16),
                      ),

                      child: Padding(
                        padding: const EdgeInsets.all(10),

                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,

                          children: [
                            // ---------------- Post title ----------------

                            Text(
                              post.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,

                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 8),

                            // ---------------- Image ----------------

                            if (post.imageUrl.isNotEmpty)
                              ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(10),

                                child: Image.network(
                                  post.imageUrl,
                                  height: 95,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              )
                            else
                              Container(
                                height: 95,
                                width: double.infinity,

                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.circular(10),
                                  color: Colors.black26,
                                ),

                                child: const Icon(
                                  Icons.image_outlined,
                                  size: 35,
                                  color: Colors.white38,
                                ),
                              ),

                            const Spacer(),

                            // ---------------- Likes ----------------

                            Row(
                              children: [
                                const Icon(
                                  Icons.favorite,
                                  size: 17,
                                  color: Colors.red,
                                ),

                                const SizedBox(width: 5),

                                Text(
                                  '${post.likesCount}',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Colors.white70,
                                  ),
                                ),

                                const Spacer(),

                                const Icon(
                                  Icons.arrow_forward_ios,
                                  size: 13,
                                  color: Colors.white38,
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
          ],
        );
      },
    );
  }
}