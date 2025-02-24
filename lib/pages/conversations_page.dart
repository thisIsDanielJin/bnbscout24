import 'package:appwrite/appwrite.dart';
import 'package:bnbscout24/api/login_manager.dart';
import 'package:bnbscout24/components/conversation_item.dart';
import 'package:bnbscout24/components/page_base.dart';
import 'package:bnbscout24/data/message.dart';
import 'package:bnbscout24/data/property.dart';
import 'package:bnbscout24/pages/conversation_page.dart';
import 'package:flutter/material.dart';
import 'package:bnbscout24/constants/sizes.dart';
import 'package:provider/provider.dart';

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
  RealtimeSubscription? realtimeSubscription;
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero,() {
      realtimeSubscription = Message.subscribeMessages();
      realtimeSubscription?.stream.listen((msg) {
        loadData();
      }); 

      loadData();
    });

    
  }

  void loadData() async {
    final loginManager = Provider.of<LoginManager>(context, listen: false);

    Map<String, PropertyMessages> propertyMessages = {};
    // ToDo Replace userId with own user id
    List<Message>? messages = await Message.listMessages(userId: loginManager.loggedInUser?.$id);

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
  void dispose() {
    super.dispose();
    realtimeSubscription?.close();
  }

  @override
  Widget build(BuildContext context) {
    return PageBase(
        title: "Conversations",
        child: Column(
          spacing: Sizes.paddingRegular,
          children: propertyMessages.values
              .map((pm) => ConversationItem(
                  title: pm.property.name,
                  description: pm.messages.last.message,
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(
                              builder: (context) => ConversationPage(property: pm.property),
                            ));
                  },
                  imageUrl: (pm.property.pictureIds?.isNotEmpty ?? false) ?
                      Property.generateImageUrls(pm.property)?.first ?? ""
                      : "https://media.istockphoto.com/id/931643150/vector/picture-icon.jpg?s=612x612&w=0&k=20&c=St-gpRn58eIa8EDAHpn_yO4CZZAnGD6wKpln9l3Z3Ok="))
              .toList()
        ));
  }
}
