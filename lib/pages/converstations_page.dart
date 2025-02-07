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
    return SafeArea(
        child: Scaffold(
            body: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
            padding: EdgeInsets.symmetric(vertical: Sizes.paddingBig),
            child: Text(
              "Profile Settings",
              style: TextStyle(
                  fontSize: Sizes.textSizeBig, fontWeight: FontWeight.bold),
            )),
      ],
    )));
  }
}
