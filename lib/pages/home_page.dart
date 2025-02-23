import 'package:bnbscout24/components/form_input.dart';
import 'package:bnbscout24/components/text_input.dart';
import 'package:flutter/material.dart';
import 'package:bnbscout24/api/login_manager.dart';
import 'package:provider/provider.dart';

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
    final loginManager = Provider.of<LoginManager>(context);
    return Container(
        child: FormInput(
      label: "Hello, ${loginManager.loggedInUser!.name}!",
      children: [TextInput()],
    ));
  }
}
