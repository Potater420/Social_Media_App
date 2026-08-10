import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LikedByBottomSheet extends StatelessWidget {
  final List<String> userIds;

  const LikedByBottomSheet({
    super.key,
    required this.userIds,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.6,
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Liked By',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const Divider(),

          Expanded(
            child: userIds.isEmpty
                ? const Center(
                    child: Text('No likes yet.'),
                  )
                : ListView.builder(
                    itemCount: userIds.length,
                    itemBuilder: (context, index) {
                      final userId = userIds[index];

                      return FutureBuilder(
                        future: FirebaseFirestore.instance
                            .collection('users')
                            .doc(userId)
                            .get(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const ListTile(
                              leading: CircleAvatar(
                                child: Icon(Icons.person),
                              ),
                              title: Text('Loading...'),
                            );
                          }

                          final data = snapshot.data!.data()
                              as Map<String, dynamic>;

                          final username =
                              data['username'] ?? 'Username';

                          final profileImage =
                              data['profileImage'] ?? '';

                          return ListTile(
                            leading: CircleAvatar(
                              backgroundImage: profileImage.isNotEmpty
                                  ? NetworkImage(profileImage)
                                  : null,
                              child: profileImage.isEmpty
                                  ? const Icon(Icons.person)
                                  : null,
                            ),
                            title: Text(username),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}