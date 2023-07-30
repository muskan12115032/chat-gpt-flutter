// ignore_for_file: use_build_context_synchronously

import 'package:chat_gpt_clone/main.dart';
import 'package:chat_gpt_clone/screens/chat_screen.dart';
import 'package:chat_gpt_clone/screens/sign_in_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Text(
                'welcome to chat gpt clone',
                style: TextStyle(
                    fontSize: 28,
                    color: Colors.white,
                    fontWeight: FontWeight.w500),
              ),
              ElevatedButton(
                  onPressed: () async {
                    SharedPreferences sharedPreferences =
                        await SharedPreferences.getInstance();
                    userId = sharedPreferences.getString('email');
                    if (userId == null) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignInScreen()));
                    } else {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ChatScreen()));
                    }
                  },
                  child: const Text('get started')),
            ],
          ),
        ),
      ),
    );
  }
}
