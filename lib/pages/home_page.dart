import 'package:flutter/material.dart';
import 'package:bnbscout24/constants/sizes.dart';
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    Sizes().initialize(context);
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Text("HOME"),
        )
      )
    );
  }
}
