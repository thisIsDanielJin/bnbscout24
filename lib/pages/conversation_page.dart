import 'package:appwrite/appwrite.dart';
import 'package:bnbscout24/api/login_manager.dart';
import 'package:bnbscout24/components/button.dart';
import 'package:bnbscout24/components/custom_text_input.dart';
import 'package:bnbscout24/components/page_base.dart';
import 'package:bnbscout24/constants/constants.dart';
import 'package:bnbscout24/constants/sizes.dart';
import 'package:bnbscout24/data/message.dart';
import 'package:bnbscout24/data/property.dart';
import 'package:bnbscout24/pages/conversations_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConversationPage extends StatefulWidget {
  final Property property;
  final String chatPartnerId;

  const ConversationPage({super.key, required this.property, required this.chatPartnerId});

  @override
  State<ConversationPage> createState() => _ConversationPageState();
}

class _ConversationPageState extends State<ConversationPage> {
  RealtimeSubscription? realtimeSubscription;
  List<Message> messages = [];
  TextEditingController messageController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    realtimeSubscription?.close();
  }

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
    
    List<MessageConversation>? convo = await Message.listMessageConverstations(userId: loginManager.loggedInUser?.$id, propertyId: widget.property.id, partnerId: widget.chatPartnerId);

    List<Message> msgs = convo!.first.messages;

    for (Message msg in msgs.where((msg) => msg.receiverId == loginManager.loggedInUser!.$id && !msg.isRead)) {
      await Message.updateMessage(msg.id, isRead: true);
    }

    setState(() {
      messages = msgs;
    });
    
  }
  @override
  Widget build(BuildContext context) {
    final loginManager = Provider.of<LoginManager>(context);

    return PageBase(title: "Conversation - ${widget.property.name}", child: Column(
      spacing: Sizes.paddingSmall,
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          flex: 1,
          child: SingleChildScrollView(
            reverse: true,
          child: Column(
            spacing: Sizes.paddingSmall,

            children: [
              ...messages.map((msg) => Align(
        alignment: msg.senderId == loginManager.loggedInUser?.$id ? Alignment.topLeft : Alignment.topRight,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Sizes.borderRadius),
            color: ColorPalette.lightGrey
          ),
          padding: EdgeInsets.all(Sizes.paddingSmall),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(msg.message,
              style: TextStyle(fontSize: Sizes.textSizeRegular),),
              Text(DateFormat("Hms").format(msg.created),
              style: TextStyle(fontSize: Sizes.textSizeSmall),)
            ],
          )
        ) ,
      )).toList() ?? [],
            ],
          ))
        ),
        Row(
          spacing: Sizes.paddingSmall,
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(child: CustomTextInput(
            controller: messageController,
          )),
          ColorButton(text: "Send!", onPressed: () {
            Message newMessage = Message(propertyId: widget.property.id, senderId: loginManager.loggedInUser!.$id, receiverId: widget.chatPartnerId!, message: messageController.text, created: DateTime.now(), isRead: false);
            Message.createMessage(newMessage);
            messageController.clear();
          })
        ],
       
       )
       
      ]
    ));
  }
}