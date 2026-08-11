import 'package:flutter/material.dart';
import 'package:social_media_app/screens/home_screen.dart';
import 'package:social_media_app/screens/loading_screen.dart';
import 'package:social_media_app/screens/sign_up_screen.dart';
import 'package:social_media_app/widgets/custom_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/cubit/auth_cubit/auth_cubit.dart';
import 'package:social_media_app/cubit/auth_cubit/auth_state.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();

  final RegExp emailRegExp = RegExp(
    r'^[\w.-]+@[\w.-]+\.\w+$',
  );

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
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
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (_) => const HomeScreen(),
            ),
            (route) => false,
          );
        }

        if (state is PasswordResetSuccess) {
          Navigator.pop(context);

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Password reset email sent! Check your inbox.',
              ),
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
              padding: const EdgeInsets.fromLTRB(
                30,
                150,
                30,
                30,
              ),

              child: Form(
                key: _formKey,

                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: [
                    // ---------------- Title ----------------

                    const Text(
                      'Welcome Back',

                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 44,
                        color: Colors.white,
                      ),
                    ),

                    const SizedBox(height: 15),

                    // ---------------- Email ----------------

                    TextFormField(
                      controller: _emailController,

                      decoration: const InputDecoration(
                        hintText: 'Input Email Here',
                        labelText: 'Email',
                        prefixIcon: Icon(Icons.email),
                      ),

                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please Enter your Email!';
                        }

                        if (!emailRegExp.hasMatch(value)) {
                          return 'Please Enter a proper Email';
                        }

                        return null;
                      },
                    ),

                    const SizedBox(height: 15),

                    // ---------------- Password ----------------

                    TextFormField(
                      obscureText: _obscurePassword,
                      controller: _passwordController,

                      decoration: InputDecoration(
                        hint: const Text(
                          'Input Password here',
                        ),

                        label: const Text(
                          'Password',
                        ),

                        prefixIcon: const Icon(
                          Icons.lock,
                        ),

                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _obscurePassword =
                                  !_obscurePassword;
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
                        if (value == null || value.isEmpty) {
                          return 'Please Enter your Password!';
                        }

                        if (value.length < 8) {
                          return 'Enter a Strong Password!';
                        }

                        return null;
                      },
                    ),

                    // ---------------- Forgot Password ----------------

                    const SizedBox(height: 5),

                    Align(
                      alignment: Alignment.centerRight,

                      child: TextButton(
                        onPressed: () {
                          final email =
                              _emailController.text.trim();

                          if (email.isEmpty) {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Please enter your email first.',
                                ),
                              ),
                            );

                            return;
                          }

                          if (!emailRegExp.hasMatch(email)) {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Please enter a valid email address.',
                                ),
                              ),
                            );

                            return;
                          }

                          context
                              .read<AuthCubit>()
                              .resetPasswordCubit(
                                email: email,
                              );
                        },

                        child: const Text(
                          'Forgot password?',

                          style: TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // ---------------- Sign In ----------------

                    CustomButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          context
                              .read<AuthCubit>()
                              .loginUserCubit(
                                email:
                                    _emailController.text.trim(),
                                password:
                                    _passwordController.text,
                              );
                        }
                      },

                      text: 'Sign in',
                    ),

                    const SizedBox(height: 24),

                    // ---------------- Sign Up ----------------

                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.center,

                      children: [
                        const Text(
                          "Don't have an account?",

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
                                builder: (_) =>
                                    const SignUpPage(),
                              ),
                            );
                          },

                          child: const Text(
                            'Sign Up',
                          ),
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