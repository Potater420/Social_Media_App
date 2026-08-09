import 'package:flutter/material.dart';
import 'package:sprints_firstapp/screens/log_in_screen.dart';
import 'package:sprints_firstapp/widgets/custom_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sprints_firstapp/cubit/auth_cubit/auth_cubit.dart';
import 'package:sprints_firstapp/cubit/auth_cubit/auth_state.dart';
import 'package:sprints_firstapp/screens/loading_screen.dart';
import 'package:sprints_firstapp/screens/home_screen.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool agreedToTerms = false;

  final _formKey = GlobalKey<FormState>();
  final RegExp emailRegExp = RegExp(r'^[\w.-]+@[\w.-]+\.\w+$');

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();

  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthLoading) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const LoadingScreen(),
            ),
          );
        }

        if (state is AuthSuccess) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => const HomeScreen(),
            ),
          );
        }

        if (state is AuthFailed) {
          Navigator.pop(context);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                context.read<AuthCubit>().errorMessage,
              ),
            ),
          );
        }
      },
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            scrolledUnderElevation: 0,
          ),
          body: SizedBox(
            width: double.infinity,
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(30, 100, 30, 30),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const Text(
                      'Create Account',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 44,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        hintText: 'Input Name Here',
                        labelText: 'Name',
                        prefixIcon: Icon(Icons.person),
                      ),
                      validator: (value) {
                        if (value == null || (value.isEmpty)) {
                          return 'Please Enter your Name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        hintText: 'Input Email Here',
                        labelText: 'Email',
                        prefixIcon: Icon(Icons.email),
                      ),
                      validator: (value) {
                        if (value == null || (value.isEmpty)) {
                          return 'Please Enter your Email!';
                        } else if (!emailRegExp.hasMatch(value)) {
                          return 'Please Enter a proper Email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      obscureText: _obscurePassword,
                      controller: _passwordController,
                      decoration: InputDecoration(
                        hint: const Text('Input Password here'),
                        label: const Text('Password'),
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || (value.isEmpty)) {
                          return 'Please Enter your Password!';
                        } else if (value.length < 8) {
                          return 'Enter a Strong Password!';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Checkbox(
                          value: agreedToTerms,
                          onChanged: (value) {
                            setState(() {
                              agreedToTerms = value!;
                            });
                          },
                        ),
                        const Text(
                          "I have read and agree to the terms and conditions",
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    CustomButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          if (!agreedToTerms) {
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "You must agree to the terms and conditions to continue.",
                                ),
                              ),
                            );

                            return;
                          }

                          context.read<AuthCubit>().createUserCubit(
                            email: _emailController.text.trim(),
                            password: _passwordController.text,
                          );
                        }
                      },
                      text: 'Sign Up',
                    ),
                    const SizedBox(height: 24),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Already have an account?",
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 15,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const SignInPage(),
                              ),
                            );
                          },
                          child: const Text("Sign In"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
