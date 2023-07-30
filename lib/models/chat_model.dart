// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ChatModel {
  final String msg;
  final int chatIndex;
  final int time;

  ChatModel({required this.time, required this.msg, required this.chatIndex});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'time': time,
      'msg': msg,
      'chatIndex': chatIndex,
    };
  }

  factory ChatModel.fromMap(Map<String, dynamic> map) {
    return ChatModel(
        msg: map['msg'] as String,
        chatIndex: map['chatIndex'] as int,
        time: map['time'] as int);
  }

  String toJson() => json.encode(toMap());
}
