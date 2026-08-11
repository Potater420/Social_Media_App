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
          return const CircularProgressIndicator();
        }

        final myPosts = (snapshot.data ?? [])
            .where((post) => post.userId == uid)
            .toList();

        if (myPosts.isEmpty) {
          return const Text('No posts yet.');
        }

        return SizedBox(
          height: 180,
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
                      builder: (_) => PostDetailsScreen(post: post),
                    ),
                  );
                },
                child: Container(
                  width: 180,
                  margin: const EdgeInsets.only(right: 12),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            post.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 6),

                          Text(
                            post.description,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),

                          const Spacer(),

                          if (post.imageUrl.isNotEmpty)
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                post.imageUrl,
                                height: 70,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),

                          const SizedBox(height: 5),

                          Row(
                            children: [
                              const Icon(
                                Icons.favorite,
                                size: 16,
                                color: Colors.red,
                              ),
                              const SizedBox(width: 4),
                              Text('${post.likesCount}'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}