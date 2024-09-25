// ignore_for_file: file_names, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:interconnect/constants.dart';

class TextMessage extends StatefulWidget {
  final TextEditingController controller;
  final ScrollController scrollController;
  final String email;

  const TextMessage({
    super.key,
    required this.controller,
    required this.scrollController,
    required this.email,
  });

  @override
  _TextMessageState createState() => _TextMessageState();
}

class _TextMessageState extends State<TextMessage> {
  bool showEmojiPicker = false;
  final FocusNode _focusNode = FocusNode();
  TextDirection textDirection = TextDirection.rtl;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if (_focusNode.hasFocus && showEmojiPicker) {
        setState(() {
          showEmojiPicker = false;
        });
      }
    });
  }

  void _toggleEmojiPicker() {
    setState(() {
      showEmojiPicker = !showEmojiPicker;
      if (showEmojiPicker) {
        FocusScope.of(context).unfocus();
      } else {
        FocusScope.of(context).requestFocus(_focusNode);
      }
    });
  }

  void _sendMessage() {
    String messageText = widget.controller.text.trim();
    if (messageText.isNotEmpty) {
      messages.add({
        'text': messageText,
        'time': DateTime.now(),
        'sender': widget.email,
      });
      widget.controller.clear();
      widget.scrollController.animateTo(0,
          duration: const Duration(milliseconds: 100), curve: Curves.easeIn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: kPrimaryColor,
          selectionColor: Color(0xFFC3C8C6),
          selectionHandleColor: kPrimaryColor,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              focusNode: _focusNode,
              controller: widget.controller,
              maxLines: null,
              minLines: 1,
              onChanged: (text) {
                setState(() {
                  textDirection = getTextDirection(text);
                });
              },
              onSubmitted: (data) {
                _sendMessage();
              },
              style: const TextStyle(
                color: kPrimaryColor,
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
              textDirection: textDirection,
              decoration: InputDecoration(
                hintText: 'Type a message...',
                hintStyle: const TextStyle(
                  color: Color(0xFF9DABA6),
                ),
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.emoji_emotions,
                        color: kPrimaryColor,
                      ),
                      onPressed: _toggleEmojiPicker,
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.send,
                        color: kPrimaryColor,
                      ),
                      onPressed: _sendMessage,
                    ),
                  ],
                ),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                    color: kPrimaryColor,
                    width: 2,
                  ),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                    color: kPrimaryColor,
                    width: 2,
                  ),
                ),
              ),
            ),
            if (showEmojiPicker)
              SizedBox(
                height: 250,
                child: EmojiPicker(
                  onEmojiSelected: (category, emoji) {
                    final text = widget.controller.text;
                    final updatedText = text + emoji.emoji;
                    widget.controller.text = updatedText;
                    widget.controller.selection = TextSelection.fromPosition(
                      TextPosition(offset: updatedText.length),
                    );
                  },
                  onBackspacePressed: () {
                    final text = widget.controller.text;

                    if (text.isNotEmpty) {
                      final newText = text.characters.skipLast(1).toString();
                      widget.controller.text = newText;

                      widget.controller.selection = TextSelection.fromPosition(
                        TextPosition(offset: newText.length),
                      );
                    }
                  },
                  config: const Config(
                      emojiViewConfig:
                          EmojiViewConfig(backgroundColor: Colors.white70),
                      categoryViewConfig: CategoryViewConfig(
                          backgroundColor: kPrimaryColor,
                          indicatorColor: Color(0xFFC9DBD4),
                          iconColor: Colors.white,
                          iconColorSelected: Color(0xFFC9DBD4),
                          backspaceColor: Colors.white),
                      bottomActionBarConfig: BottomActionBarConfig(
                        backgroundColor: kPrimaryColor,
                        buttonColor: Colors.transparent,
                        buttonIconColor: Colors.white,
                      ),
                      searchViewConfig:
                          SearchViewConfig(buttonIconColor: kPrimaryColor)),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
