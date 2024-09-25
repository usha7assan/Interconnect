// ignore_for_file: file_names, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:interconnect/Screens/signInPage.dart';
import 'package:interconnect/components/ChatWidget.dart';
import 'package:interconnect/components/TextMessage.dart';
import 'package:interconnect/constants.dart';
import 'package:interconnect/models/messageModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatPage extends StatefulWidget {
  final String email;
  const ChatPage({super.key, required this.email});
  static const String id = 'ChatPage';

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final ScrollController _controller = ScrollController();
  final TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              kLogo,
              width: 30,
              height: 30,
            ),
            const Text(
              'Interconnect',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontFamily: "BaskervvilleSC",
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () async {
              SharedPreferences preferences =
                  await SharedPreferences.getInstance();
              await preferences.clear();
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (c) => const SignInPage()));
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: messages.orderBy('time', descending: true).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: kPrimaryColor,
              ),
            );
          }

          List<MessageModel> messagesList = snapshot.data!.docs.map((doc) {
            var data = doc.data() as Map<String, dynamic>;
            return MessageModel.fromJson(data);
          }).toList();

          return Column(
            children: [
              const SizedBox(height: 1),
              Expanded(
                child: ListView.builder(
                  reverse: true,
                  controller: _controller,
                  itemCount: messagesList.length,
                  itemBuilder: (context, index) {
                    return messagesList[index].sender == widget.email
                        ? ChatWidget(message: messagesList[index])
                        : ChatWidgetForFriend(message: messagesList[index]);
                  },
                ),
              ),
              TextMessage(
                controller: _textController,
                email: widget.email,
                scrollController: _controller,
              ),
            ],
          );
        },
      ),
    );
  }
}
