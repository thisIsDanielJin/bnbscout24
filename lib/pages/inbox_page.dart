import 'package:flutter/material.dart';
import 'package:bnbscout24/constants/sizes.dart';
class InboxPage extends StatefulWidget {
  const InboxPage({super.key});

  @override
  State<InboxPage> createState() => _InboxPageState();
}

class _InboxPageState extends State<InboxPage> {
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
