import 'package:flutter/material.dart';
import 'package:sprints_firstapp/sign_in_page.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/background.jfif'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent,
        body: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,

            children: [
              Spacer(),
              Column(
                children: [
                  Text(
                    'Welcome Back!',
                    style: TextStyle(
                      fontSize: 44,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Enter personal details to your employee account',
                    style: TextStyle(color: Colors.white, fontSize: 24),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),

              Spacer(),

              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        showModalBottomSheet(
                          isScrollControlled: true,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(30),
                            ),
                          ),
                          context: context,
                          builder: (context) {
                            return SizedBox(
                              height: MediaQuery.of(context).size.height * 0.7,
                              child: SignInPage(),
                            );
                          },
                        );
                      },
                      child: Text(
                        'Sign in',
                        style: TextStyle(color: Colors.white, fontSize: 24),
                      ),
                    ),
                  ),

                  Expanded(
                    child: Container(
                      height: 90,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                        ),
                      ),

                      child: Center(
                        child: TextButton(
                          onPressed: () {},
                          child: Text(
                            'Sign up',
                            style: TextStyle(
                              color: const Color.fromARGB(255, 9, 88, 152),
                              fontSize: 24,
                            ),
                          ),
                        ),
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
