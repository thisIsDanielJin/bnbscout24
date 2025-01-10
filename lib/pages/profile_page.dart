import 'package:flutter/material.dart';
import 'package:bnbscout24/constants/sizes.dart';
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    Sizes().initialize(context);
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Text("PROFILE"),
        )
      )
    );
  }
}
