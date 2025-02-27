import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../api/login_manager.dart';
import '../constants/constants.dart';
import '../constants/sizes.dart';
import '../data/message.dart';

class ConversationTabBarItem extends StatefulWidget {
  const ConversationTabBarItem({super.key});

  @override
  State<ConversationTabBarItem> createState() => _ConversationTabBarItemState();
}

class _ConversationTabBarItemState extends State<ConversationTabBarItem> {
  RealtimeSubscription? messageSub;
  int messages = 0;

  void loadMessages() async {
    final loginManager = Provider.of<LoginManager>(context, listen: false);
    List<MessageConversation>? message = await Message.listMessageConverstations(userId: loginManager.loggedInUser!.$id);
    if (message != null) {
      setState(() {
        messages = message.where((msg) => msg.isNew == true).length;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    messageSub?.close();
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      messageSub = Message.subscribeMessages();

      messageSub?.stream.listen((msg) {
        loadMessages();
      });
      loadMessages();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FaIcon(FontAwesomeIcons.inbox,
            size: Sizes.navBarIconSize),
        if (messages > 0) Positioned(
            top: 0,
            left: 4,
            child: Container(
                width: 16,
                height: 16,
                alignment: Alignment.center,
                decoration: BoxDecoration(color: ColorPalette.primary, borderRadius: BorderRadius.circular(7)),
                child: Text(messages.toString(),
                  style: TextStyle(fontSize: 12),)
            ))
      ],
    );
  }
}
