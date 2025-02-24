import 'package:bnbscout24/constants/sizes.dart';
import 'package:flutter/material.dart';

class PageBase extends StatelessWidget {
  final Widget child;
  final String title;

  const PageBase(
      {super.key,
      required this.child,
      required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      padding: EdgeInsets.all(Sizes.paddingRegular),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(spacing: Sizes.paddingSmall, children: [
            if (Navigator.canPop(context))
              IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            Padding(
                padding: EdgeInsets.symmetric(vertical: Sizes.paddingBig),
                child: Text(
                  title,
                  style: TextStyle(
                      fontSize: Sizes.textSizeBig, fontWeight: FontWeight.bold),
                )),
          ]),
            child
        ],
      ),
    ));
  }
}
