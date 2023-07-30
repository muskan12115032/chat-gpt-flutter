import 'package:chat_gpt_clone/constants/constants.dart';
import 'package:chat_gpt_clone/providers/chat_provider.dart';
import 'package:chat_gpt_clone/providers/models_provider.dart';
import 'package:chat_gpt_clone/screens/chat_screen.dart';
import 'package:chat_gpt_clone/screens/login_screen.dart';
import 'package:chat_gpt_clone/screens/sign_in_screen.dart';
import 'package:chat_gpt_clone/screens/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

String? userId;
void main(List<String> args) {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ModelsProvider()),
        ChangeNotifierProvider(create: (context) => ChatProvider()),
      ],
      child: MaterialApp(
          title: 'Chat GPT Clone',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
              scaffoldBackgroundColor: scaffoldBackGroundColor,
              appBarTheme: AppBarTheme(color: cardColor)),
          home: FutureBuilder(
            future: check(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data == true) {
                  return const ChatScreen();
                } else {
                  return const LoginScreen();
                }
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          )),
    );
  }
}

Future<bool> check() async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  userId = sharedPreferences.getString('email');
  if (userId == null) return false;
  return true;
}
