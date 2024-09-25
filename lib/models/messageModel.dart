// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final String text;

  final Timestamp time;
  final String sender;

  MessageModel({required this.sender, required this.text, required this.time});
  factory MessageModel.fromJson(json) {
    return MessageModel(
      text: json['text'],
      time: json['time'],
      sender: json['sender'],
    );
  }
}
