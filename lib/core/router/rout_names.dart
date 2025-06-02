/*import 'package:ex_chat_app/pages/chatpage.dart';
import 'package:ex_chat_app/pages/forgotpassword.dart';
import 'package:ex_chat_app/pages/home.dart';
import 'package:ex_chat_app/pages/signin.dart';
import 'package:ex_chat_app/pages/signup.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';


class Routes {
  static const String signIn = '/signin';
  static const String signUp = '/signup';
  static const String forgotPassword = '/forgotpassword';
  static const String home = '/';
  static const String chatPage = '/chatpage';

  static final GoRouter router = GoRouter(
    initialLocation: signIn,
    routes: [
      GoRoute(
        path: signIn,
        name: 'signin',
        builder: (context, state) => SignIn(),
      ),
      GoRoute(
        path: signUp,
        name: 'signup',
        builder: (context, state) => SignUp(),
      ),
      GoRoute(
        path: forgotPassword,
        name: 'forgotpassword',
        builder: (context, state) => ForgotPassword(),
      ),
      GoRoute(
        path: home,
        name: 'home',
        builder: (context, state) => Home(),
      ),
      GoRoute(
  path: Routes.chatPage,
  name: 'chatpage',
  builder: (context, state) {
    final args = state.extra as ChatPage;
    return ChatPage(
      name: args.name,
      profileurl: args.profileurl,
      username: args.username,
    );
  },
),

    ],
  );
}*/
