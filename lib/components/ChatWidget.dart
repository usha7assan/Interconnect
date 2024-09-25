// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:interconnect/constants.dart';
import 'package:interconnect/models/messageModel.dart';
import 'package:intl/intl.dart' as intl;

class ChatWidget extends StatefulWidget {
  final MessageModel message;
  const ChatWidget({super.key, required this.message});

  @override
  State<ChatWidget> createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> {
  @override
  Widget build(BuildContext context) {
    String formattedTime =
        intl.DateFormat('h:mm a').format(widget.message.time.toDate());

    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.all(15),
        margin: const EdgeInsets.all(5),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40),
            topRight: Radius.circular(40),
            bottomRight: Radius.circular(40),
          ),
          color: kPrimaryColor,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              widget.message.sender
                  .substring(0, widget.message.sender.indexOf('@')),
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              widget.message.text,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
              textDirection: getTextDirection(widget.message.text),
              textAlign: TextAlign.end,
            ),
            const SizedBox(height: 5),
            Text(
              formattedTime,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatWidgetForFriend extends StatefulWidget {
  final MessageModel message;
  const ChatWidgetForFriend({super.key, required this.message});

  @override
  State<ChatWidgetForFriend> createState() => _ChatWidgetForFriendState();
}

class _ChatWidgetForFriendState extends State<ChatWidgetForFriend> {
  @override
  Widget build(BuildContext context) {
    String formattedTime =
        intl.DateFormat('h:mm a').format(widget.message.time.toDate());

    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.all(5),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40),
            topRight: Radius.circular(40),
            bottomLeft: Radius.circular(40),
          ),
          color: Color(0xFF84A095),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              widget.message.sender
                  .substring(0, widget.message.sender.indexOf('@')),
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              widget.message.text,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
              textDirection: getTextDirection(widget.message.text),
            ),
            const SizedBox(height: 5),
            Text(
              formattedTime,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
