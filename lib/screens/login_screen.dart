// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:chat_gpt_clone/constants/constants.dart';
import 'package:chat_gpt_clone/main.dart';
import 'package:chat_gpt_clone/screens/chat_screen.dart';
import 'package:chat_gpt_clone/screens/sign_in_screen.dart';
import 'package:chat_gpt_clone/services/api_services.dart';
import 'package:chat_gpt_clone/services/assets_manager.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController emailController;
  late TextEditingController passwordController;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  login() async {
    if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      String response = await ApiServices.login(
          userId: emailController.text.trim(),
          password: passwordController.text.trim());
      if (jsonDecode(response)['success'] == true) {
        SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();
        sharedPreferences.setString('email', emailController.text.trim());
        userId = emailController.text.trim();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('user logged in successfully'),
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(jsonDecode(response)['message']),
        ));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('please fill all Required fields'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 5,
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(AssetsManager.openAiLogo),
          ),
          title: const Text('Log In'),
        ),
        body: Center(
          child: Container(
            height: MediaQuery.of(context).size.height * 0.45,
            width: MediaQuery.of(context).size.width * 0.9,
            decoration: BoxDecoration(
                color: cardColor, borderRadius: BorderRadius.circular(30)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      TextField(
                        style: const TextStyle(color: Colors.white),
                        controller: emailController,
                        decoration: const InputDecoration(
                          hintText: 'enter your email',
                          hintStyle: TextStyle(color: Colors.white),
                        ),
                      ),
                      TextField(
                        controller: passwordController,
                        obscureText: true,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          hintText: 'enter your password',
                          hintStyle: TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      ElevatedButton(
                          onPressed: () async {
                            await login();
                            if (userId != null) {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const ChatScreen()));
                            }
                          },
                          child: const Text('Login')),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const SignInScreen()));
                              },
                              child: Row(
                                children: const [
                                  Text(
                                    'new user? Sign In',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                  ),
                                  Icon(
                                    Icons.arrow_right_alt,
                                    color: Colors.lightBlue,
                                  )
                                ],
                              )),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
