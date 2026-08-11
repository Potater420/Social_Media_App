import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/cubit/auth_cubit/auth_cubit.dart';
import 'package:social_media_app/cubit/post_cubit/post_cubit.dart';
import 'package:social_media_app/screens/splash_screen.dart';
import 'package:social_media_app/theme/app_theme.dart';
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
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthCubit(),
        ),
        BlocProvider(
          create: (context) => PostCubit(),
        ),
      ],

      child: MaterialApp(
        theme: AppTheme.darkTheme,
        title: 'ConnectHub',
        debugShowCheckedModeBanner: false,

        // Start with Splash Screen
        home: const SplashScreen(),
      ),
    );
  }
}
