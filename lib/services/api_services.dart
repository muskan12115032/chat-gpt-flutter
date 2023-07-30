import 'dart:convert';
import 'dart:io';

import 'package:chat_gpt_clone/constants/api_constants.dart';
import 'package:chat_gpt_clone/main.dart';
import 'package:chat_gpt_clone/models/chat_model.dart';
import 'package:chat_gpt_clone/models/model.dart';
import 'package:http/http.dart' as http;

class ApiServices {
  static Future<List<Model>> getModels() async {
    try {
      var responce = await http.get(Uri.parse('$baseUrl/models'),
          headers: {'Authorization': 'Bearer $apikey'});
      Map jsonResponce = jsonDecode(responce.body);
      if (jsonResponce['error'] != null) {
        throw HttpException(jsonResponce['error']["message"]);
      }
      List temp = [];
      for (var value in jsonResponce["data"]) {
        temp.add(value);
      }
      return Model.modelsFromSnapShot(temp);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  static Future<List<ChatModel>> getMessagesFromServer(
      {required String userId}) async {
    var data = await http.post(
        Uri.parse(
            "https://chat-gpt-backend-a8m1.onrender.com/api/message/getmessages"),
        body: {"email": userId});
    var jsonData = json.decode(data.body);
    List<ChatModel> messages = [];
    for (var m in jsonData['message']) {
      ChatModel message = ChatModel(
          chatIndex: m['chatIndex'], msg: m['message'], time: m['time']);
      messages.add(message);
    }
    return messages;
  }

  static Future<void> storeMessageToDatabase(
      {required String message, required int chatIndex}) async {
    try {
      var response = await http.post(
        Uri.parse(
            "https://chat-gpt-backend-a8m1.onrender.com/api/message/sendmessage"),
        body: {
          "email": userId,
          "message": message,
          "chatIndex": "$chatIndex",
          "time": "${DateTime.now().millisecondsSinceEpoch}"
        },
      );
    } catch (e) {
      print(e.toString());
    }
  }

  static Future<String> createAccount(
      {required String userId,
      required String password,
      required String fullName}) async {
    var response = await http.post(
        Uri.parse(
            "https://chat-gpt-backend-a8m1.onrender.com/api/user/createaccount"),
        body: {"email": userId, "password": password, "fullName": fullName});
    if (response.statusCode == 200) {
      if (json.decode(response.body)['message'].contains('duplicate key')) {
        return 'user already exists';
      }
      if (json
          .decode(response.body)['message']
          .contains('created successfully')) {
        return json.decode(response.body)['message'];
      }
      return json.decode(response.body)['message'];
    } else {
      return 'error occurred';
    }
  }

  static Future<String> login(
      {required String userId, required String password}) async {
    var response = await http.post(
        Uri.parse("https://chat-gpt-backend-a8m1.onrender.com/api/user/login"),
        body: {"email": userId, "password": password});
    if (response.statusCode == 200) {
      return response.body;
    } else {
      return '{"success":false,"message": "error occurred"}';
    }
  }

  static Future<List<ChatModel>> sendMessage(
      {required String message, required String modelId}) async {
    try {
      var response = await http.post(
        Uri.parse('$baseUrl/completions'),
        headers: {
          'Authorization': 'Bearer $apikey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "model": modelId,
          "prompt": message,
          "max_tokens": 100,
        }),
      );
      Map jsonResponse = jsonDecode(response.body);
      if (jsonResponse['error'] != null) {
        throw HttpException(jsonResponse['error']["message"]);
      }
      List<ChatModel> chatList = [];
      if (jsonResponse['choices'].length > 0) {
        chatList = List.generate(jsonResponse['choices'].length, (index) {
          ApiServices.storeMessageToDatabase(
              message: jsonResponse["choices"][index]["text"], chatIndex: 1);
          return ChatModel(
              chatIndex: 1,
              msg: jsonResponse["choices"][index]["text"],
              time: DateTime.now().millisecondsSinceEpoch);
        });
      }
      return chatList;
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
