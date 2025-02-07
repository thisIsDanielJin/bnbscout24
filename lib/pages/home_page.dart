import 'package:bnbscout24/components/form_input.dart';
import 'package:bnbscout24/components/custom_text_input.dart';
import 'package:bnbscout24/constants/sizes.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, Sizes.paddingBig, 0, 0),
      child: Column(
  
        children: [
          Text("Home")
        ],
      )
    );
  }
}
