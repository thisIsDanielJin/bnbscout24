import 'package:bnbscout24/constants/constants.dart';
import 'package:bnbscout24/constants/sizes.dart';
import 'package:bnbscout24/pages/conversation_page.dart';
import 'package:flutter/material.dart';

class ConversationItem extends StatelessWidget {
  final String title;
  final String description;
  final String imageUrl;
  final bool? isNew;

  const ConversationItem(
      {super.key,
      required this.title,
      required this.description,
      required this.imageUrl,
      this.isNew});

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
          borderRadius: BorderRadius.circular(Sizes.borderRadius),
          child: Container(
            decoration: BoxDecoration(
              color: ColorPalette.lighterGrey,
            ),
            height: 112,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
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
                Container(
                  padding: EdgeInsets.all(Sizes.paddingSmall),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 22,
                        padding: EdgeInsets.fromLTRB(
                            Sizes.paddingSmall, 0, Sizes.paddingSmall, 0),
                        decoration: BoxDecoration(
                            color: ColorPalette.primary,
                            borderRadius:
                                BorderRadius.circular(Sizes.borderRadiusBig)),
                        child: Text("new"),
                      ),
                      // Icon(Icons.hide_image, size: 32),
                      Icon(Icons.arrow_forward_ios, size: 32),
                      Container(height: 24)
                    ],
                  ),
                )
              ],
            ),
          )),
    );
  }
}
