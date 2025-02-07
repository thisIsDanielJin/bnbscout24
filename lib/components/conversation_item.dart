import 'package:bnbscout24/constants/constants.dart';
import 'package:bnbscout24/constants/sizes.dart';
import 'package:bnbscout24/pages/conversation_page.dart';
import 'package:flutter/material.dart';

class ConversationItem extends StatelessWidget {
  final String title;
  final String description;
  final String imageUrl;

  const ConversationItem(
      {super.key,
      required this.title,
      required this.description,
      required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ConversationPage(messageId: title),
        ));
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6.0),
        child: Container(
          decoration: BoxDecoration(
            color: ColorPalette.lighterGrey,
          ),
          height: 96,
          child: Row(
            children: [
              Image.network(imageUrl),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(Sizes.paddingRegular),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                            fontSize: Sizes.textSizeRegular,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(description)
                    ],
                  ),
                ),
              ),
              Icon(Icons.arrow_forward_ios, size: 32)
            ],
          ),
        )),

    )
      ;
  }
}
