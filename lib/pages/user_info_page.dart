import 'package:flutter/material.dart';
import 'package:bnbscout24/constants/sizes.dart';
import 'package:bnbscout24/api/login_manager.dart';
import 'package:provider/provider.dart';

class UserInformationPage extends StatefulWidget {
  const UserInformationPage({super.key});

  @override
  State<UserInformationPage> createState() => _UserInformationPageState();
}

class _UserInformationPageState extends State<UserInformationPage> {
  @override
  Widget build(BuildContext context) {
    final loginManager = Provider.of<LoginManager>(context);

    return SafeArea(
        child: Scaffold(
            body: Container(
                padding: EdgeInsets.all(Sizes.paddingRegular),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: Sizes.paddingSmall,
                  children: [
                    Row(spacing: Sizes.paddingSmall, children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      Padding(
                          padding:
                              EdgeInsets.symmetric(vertical: Sizes.paddingBig),
                          child: Text(
                            "Settings",
                            style: TextStyle(
                                fontSize: Sizes.textSizeBig,
                                fontWeight: FontWeight.bold),
                          )),
                    ]),
                    Row(children: [
                      Text('User ID: ',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(loginManager.loggedInUser?.$id ?? "")
                    ]),
                    Row(children: [
                      Text('Name: ',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(loginManager.loggedInUser?.name ?? "")
                    ]),
                    Row(children: [
                      Text('Email: ',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(loginManager.loggedInUser?.email ?? "")
                    ]),
                    Row(children: [
                      Text('Account Type: ',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(
                          loginManager.isLandlord ? 'Landlord' : 'Default User')
                    ]),
                  ],
                ))));
  }
}
