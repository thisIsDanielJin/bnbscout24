import 'package:flutter/material.dart';

class ConversationPage extends StatefulWidget {
  final String messageId;

  const ConversationPage({super.key, required this.messageId});

  @override
  State<ConversationPage> createState() => _ConversationPageState();
}

class _ConversationPageState extends State<ConversationPage> {
  @override
  Widget build(BuildContext context) {

    return Text(widget.messageId);
  }
}