import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sprints_firstapp/cubit/auth_cubit/auth_cubit.dart';
import 'package:sprints_firstapp/screens/welcome_screen.dart';
import 'package:sprints_firstapp/theme/app_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(),
      child: MaterialApp(
        theme: AppTheme.darkTheme,
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        home: const WelcomePage(),
      ),
    );
  }
}
