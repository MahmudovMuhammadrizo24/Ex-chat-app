import 'package:ex_chat_app/firebase_options.dart';
import 'package:ex_chat_app/pages/home.dart';
import 'package:ex_chat_app/pages/signin.dart';
import 'package:ex_chat_app/pages/signup.dart';
import 'package:ex_chat_app/service/auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

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
    return MaterialApp(
      title: 'Chat App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: FutureBuilder(
        future: AuthMethods().getcurrentUser(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasData) {
            return const Home(); // foydalanuvchi tizimga kirgan bo‘lsa
          } else {
            return const SignUp(); // foydalanuvchi hali login qilmagan bo‘lsa
          }
        },
      ),
    );
  }
}
