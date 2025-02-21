import 'package:bnbscout24/pages/create_property.dart';
import 'package:flutter/material.dart';
import 'package:bnbscout24/constants/sizes.dart';
import 'package:bnbscout24/components/button.dart';

class PropertiesPage extends StatefulWidget {
  const PropertiesPage({super.key});

  @override
  State<PropertiesPage> createState() => _PropertiesPageState();
}

class _PropertiesPageState extends State<PropertiesPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: Container(
                padding: EdgeInsets.all(Sizes.paddingRegular),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                          padding:
                              EdgeInsets.symmetric(vertical: Sizes.paddingBig),
                          child: Text(
                            "Your Properties",
                            style: TextStyle(
                                fontSize: Sizes.textSizeBig,
                                fontWeight: FontWeight.bold),
                          )),
                      Column(spacing: Sizes.paddingRegular, children: [
                        SquareArrowButton(text: "Add Property", onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const CreatePropertyPage(),
                            ),
                          );
                        })
                      ]),
                     
                    ]))));
  }
}
