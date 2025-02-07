import 'package:bnbscout24/components/conversation_item.dart';
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
        child: Container(
            padding: EdgeInsets.all(Sizes.paddingRegular),
            child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
            padding: EdgeInsets.symmetric(vertical: Sizes.paddingBig),
            child: Text(
              "Conversations",
              style: TextStyle(
                  fontSize: Sizes.textSizeBig, fontWeight: FontWeight.bold),
            )),
            Column(
              spacing: Sizes.paddingRegular,
              children: [
                ConversationItem(
                  imageUrl: "https://picsum.photos/250?image=9",
                  title: "Message 1",
                  description: "dweiaojkm asiodk asi fkma opsakdlf,",
                  isNew: true,
                ),
                ConversationItem(
                  imageUrl: "https://picsum.photos/250?image=10",
                  title: "Message 2",
                  description: "dweiaojkm asiodk asi fkma opsakdlf,",
                )
            ],)
            
      ],
    )));
  }
}
