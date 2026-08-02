import 'package:flutter/material.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  bool rememberMe = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(35)),
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: [
              Text(
                'Welcome Back',
                style: TextStyle(
                  fontSize: 44,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 9, 88, 152),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Email',
                  hintText: 'Enter email here',
                ),
              ),
              SizedBox(height: 10),
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  hintText: 'Enter Password here',
                ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Checkbox(
                    activeColor: const Color.fromARGB(255, 9, 88, 152),
                    value: rememberMe,
                    onChanged: (value) {
                      setState(() {
                        rememberMe = value!;
                      });
                    },
                  ),
                  Text("Remember me", style: TextStyle(fontSize: 12)),
                  Spacer(),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'Forgot password?',
                      style: TextStyle(
                        fontSize: 12,
                        color: const Color.fromARGB(255, 9, 88, 152),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
