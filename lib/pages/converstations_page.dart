import 'package:flutter/material.dart';
import 'package:bnbscout24/constants/sizes.dart';
class ConversationsPage extends StatefulWidget {
  const ConversationsPage({super.key});

  @override
  State<ConversationsPage> createState() => _ConversationsPageState();
}

class _ConversationsPageState extends State<ConversationsPage> {
  @override
  Widget build(BuildContext context) {
    Sizes().initialize(context);
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Text("INBOX"),
        )
      )
    );
  }
}
