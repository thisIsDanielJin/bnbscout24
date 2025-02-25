import 'package:bnbscout24/constants/constants.dart';
import 'package:bnbscout24/constants/sizes.dart';
import 'package:bnbscout24/pages/conversation_page.dart';
import 'package:flutter/material.dart';

class ConversationItem extends StatelessWidget {
  final String title;
  final String description;
  final String imageUrl;
  final bool? isNew;
  final VoidCallback? onPressed;

  const ConversationItem(
      {super.key,
      required this.title,
      required this.description,
      required this.imageUrl,
      this.onPressed,
      this.isNew});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorPalette.lightGrey,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: EdgeInsets.all(0),
          elevation: 0, // No shadow
        ),
        onPressed: onPressed,
        child: SizedBox(
            height: 110,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ClipRRect(
                  
                  borderRadius: BorderRadius.circular(Sizes.borderRadius),
                  child: Image.network(imageUrl, width: 160),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(Sizes.paddingRegular),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                              color: ColorPalette.black,
                              fontSize: Sizes.textSizeRegular,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(description,
                        style: TextStyle(
                              color: ColorPalette.darkGrey,
                              fontSize: Sizes.textSizeSmall),
                        )
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
                        child: Text(
                          "new",
                          style: TextStyle(
                            color: ColorPalette.white
                          ),
                        ),
                      ),
                      Icon(Icons.arrow_forward_ios, 
                      size: 32,
                      color: ColorPalette.black,),
                      Container(height: 24)
                    ],
                  ),
                )
              ],
            )));
  }
}
