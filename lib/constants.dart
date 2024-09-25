import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

const kPrimaryColor = Color(0xFF023020);
const kLogo = 'assets/images/meetme.png';
const kMessagesCollection = 'messages';

CollectionReference messages =
    FirebaseFirestore.instance.collection(kMessagesCollection);

TextDirection getTextDirection(String text) {
  return RegExp(r'^[\u0600-\u06FF]').hasMatch(text)
      ? TextDirection.rtl
      : TextDirection.ltr;
}
