// ignore_for_file: use_build_context_synchronously

import 'package:chat_gpt_clone/constants/constants.dart';
import 'package:chat_gpt_clone/screens/login_screen.dart';
import 'package:chat_gpt_clone/services/api_services.dart';
import 'package:chat_gpt_clone/services/assets_manager.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController nameController;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    nameController = TextEditingController();
  }

  signIn() async {
    if (emailController.text.isNotEmpty &&
        passwordController.text.isNotEmpty &&
        nameController.text.isNotEmpty) {
      String response = await ApiServices.createAccount(
          userId: emailController.text.trim(),
          fullName: nameController.text.trim(),
          password: passwordController.text.trim());
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(response),
      ));
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
          title: const Text('Create Account'),
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
                        controller: nameController,
                        decoration: const InputDecoration(
                          hintText: 'enter your full name',
                          hintStyle: TextStyle(color: Colors.white),
                        ),
                      ),
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
                          onPressed: () {
                            signIn();
                          },
                          child: const Text('Create Account')),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const LoginScreen()));
                              },
                              child: Row(
                                children: const [
                                  Text(
                                    'Login Instead',
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
