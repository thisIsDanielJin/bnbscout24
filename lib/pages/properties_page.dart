import 'package:flutter/material.dart';
import 'package:bnbscout24/constants/sizes.dart';
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
        body: Center(
          child: Text("PROPERTIES"),
        )
      )
    );
  }
}
