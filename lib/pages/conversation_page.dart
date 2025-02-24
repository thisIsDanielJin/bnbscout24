import 'package:bnbscout24/components/page_base.dart';
import 'package:bnbscout24/data/message.dart';
import 'package:flutter/material.dart';

class ConversationPage extends StatefulWidget {
  final List<Message> messages;
  
  const ConversationPage({super.key, required this.messages});

  @override
  State<ConversationPage> createState() => _ConversationPageState();
}

class _ConversationPageState extends State<ConversationPage> {
  @override
  Widget build(BuildContext context) {
    String ownId = "OwnID";
    return PageBase(title: "Conversation", child: Column(
      children: widget.messages.map((msg) => Align(
        alignment: msg.senderId == ownId ? Alignment.topLeft : Alignment.topRight,
        child: Text(msg.message),
      )).toList()
    ));
  }
}