import 'package:flutter/material.dart';
import 'package:sprints_firstapp/screens/user_profile_screen.dart';

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
      body: const Center(
        child: Text(
          'Welcome to ConnectHub!',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
