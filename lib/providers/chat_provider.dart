import 'package:chat_gpt_clone/main.dart';
import 'package:chat_gpt_clone/models/chat_model.dart';
import 'package:chat_gpt_clone/services/api_services.dart';
import 'package:flutter/cupertino.dart';

class ChatProvider with ChangeNotifier {
  List<ChatModel> chatList = [];
  bool isTyping = false;
  bool loadingChat = true;
  ChatProvider() {
    getMessages();
  }
  List<ChatModel> get getChatList {
    return chatList;
  }

  getMessages() async {
    chatList.addAll(await ApiServices.getMessagesFromServer(userId: userId!));
    loadingChat = false;
    notifyListeners();
  }

  void addUserMessage(String message) async {
    chatList.add(ChatModel(
        msg: message,
        chatIndex: 0,
        time: DateTime.now().millisecondsSinceEpoch));
    notifyListeners();
    await ApiServices.storeMessageToDatabase(message: message, chatIndex: 0);
  }

  Future<void> sendMessagesAndGetAnswers(
      {required String message, required String modelId}) async {
    chatList.addAll(
        await ApiServices.sendMessage(message: message, modelId: modelId));
    notifyListeners();
  }

  // ignore: non_constant_identifier_names
  bool get Typing {
    return isTyping;
  }

  Stream<List<ChatModel>> getMessagesStreamFromServer(String userId) {
    return Stream.fromFuture(ApiServices.getMessagesFromServer(userId: userId));
  }

  // ignore: non_constant_identifier_names
  void toggleTyping() {
    isTyping = !isTyping;
    notifyListeners();
  }
}
