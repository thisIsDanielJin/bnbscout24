import 'package:bnbscout24/components/conversation_item.dart';
import 'package:bnbscout24/components/page_base.dart';
import 'package:bnbscout24/data/message.dart';
import 'package:bnbscout24/data/property.dart';
import 'package:flutter/material.dart';
import 'package:bnbscout24/constants/sizes.dart';

class PropertyMessages {
  final List<Message> messages;
  final Property property;

  PropertyMessages({required this.messages, required this.property});
}

class ConversationsPage extends StatefulWidget {
  const ConversationsPage({super.key});

  @override
  State<ConversationsPage> createState() => _ConversationsPageState();
}

class _ConversationsPageState extends State<ConversationsPage> {
  Map<String, PropertyMessages> propertyMessages = {};

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    Map<String, PropertyMessages> propertyMessages = {};
    // ToDo Replace userId with own user id
    List<Message>? messages = await Message.listMessages(userId: "Unknown");
    if (messages != null) {
      for (Message message in messages) {
        if (propertyMessages.containsKey(message.propertyId)) {
          propertyMessages[message.propertyId]!.messages.add(message);
          continue;
        }
        Property? property = await Property.getPropertyById(message.propertyId);
        if (property != null) {
          propertyMessages[message.propertyId] =
              PropertyMessages(messages: [message], property: property);
        }
      }
    }
    setState(() {
      this.propertyMessages = propertyMessages;
    });
  }

  @override
  Widget build(BuildContext context) {
    return PageBase(
        title: "Conversations",
        child: Column(
          spacing: Sizes.paddingRegular,
          children: propertyMessages.isEmpty ? [Text("No Conversations :/")] :
             propertyMessages.values
              .map((pm) => ConversationItem(
                  title: pm.property.name,
                  description: pm.messages.last.message,
                  imageUrl:
                      Property.generateImageUrls(pm.property)?.first ?? ""))
              .toList(),
        ));
  }
}
