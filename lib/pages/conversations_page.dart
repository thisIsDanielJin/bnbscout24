import 'package:appwrite/appwrite.dart';
import 'package:bnbscout24/api/login_manager.dart';
import 'package:bnbscout24/components/conversation_item.dart';
import 'package:bnbscout24/components/page_base.dart';
import 'package:bnbscout24/constants/constants.dart';
import 'package:bnbscout24/data/message.dart';
import 'package:bnbscout24/data/property.dart';
import 'package:bnbscout24/pages/conversation_page.dart';
import 'package:flutter/material.dart';
import 'package:bnbscout24/constants/sizes.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PropertyConversation {
  final MessageConversation conversation;
  final Property property;

  PropertyConversation({required this.property, required this.conversation});
}

class ConversationsPage extends StatefulWidget {
  const ConversationsPage({super.key});

  @override
  State<ConversationsPage> createState() => _ConversationsPageState();
}

class _ConversationsPageState extends State<ConversationsPage> {
  List<PropertyConversation> propertyMessages = [];
  RealtimeSubscription? realtimeSubscription;
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      realtimeSubscription = Message.subscribeMessages();

      realtimeSubscription?.stream.listen((msg) {
        loadData();
      });

      loadData();
    });
  }

  void loadData() async {
    final loginManager = Provider.of<LoginManager>(context, listen: false);

    List<MessageConversation>? conversations =
        await Message.listMessageConverstations(
            userId: loginManager.loggedInUser?.$id);
    print(conversations);
    if (conversations != null) {
      List<PropertyConversation> mc = [];
      for (MessageConversation convo in conversations) {
        mc.add(PropertyConversation(
            property: (await Property.getPropertyById(convo.propertyId))!,
            conversation: convo));
      }
      //Note: mounted check is needed to prevent the app from crashing after landlord upgrade.
      //TODO: why is there still data being loaded after the page was disposed?
      //TODO: is this also happening for other pages?
      if (mounted) {
        setState(() {
          propertyMessages = mc;
        });
      }
    }
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
        child: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: Sizes.navBarFullSize),
          child: Column(
              spacing: Sizes.paddingRegular,
              children: propertyMessages
                  .map((pm) => ConversationItem(
                      title: pm.property.name,
                      description: pm.conversation.messages.last.message,
                      isNew: pm.conversation.isNew,
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ConversationPage(
                                property: pm.property,
                                chatPartnerId: pm.conversation.chatPartnerId,
                              ),
                            ));
                      },
                      imageUrl: (pm.property.pictureIds?.isNotEmpty ?? false)
                          ? Property.generateImageUrls(pm.property)?.first ?? ""
                          : Constants.unknownImageUrl))
                  .toList()),
        ));
  }
}
