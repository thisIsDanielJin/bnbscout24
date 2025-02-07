import 'package:flutter/material.dart';
import 'package:bnbscout24/constants/sizes.dart';
import 'package:bnbscout24/components/button.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
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
                            "Profile Settings",
                            style: TextStyle(
                                fontSize: Sizes.textSizeBig,
                                fontWeight: FontWeight.bold),
                          )),
                      Column(spacing: Sizes.paddingRegular, children: [
                        SquareArrowButton(
                            text: "User Information", onPressed: () {}),
                        SquareArrowButton(
                            text: "Change Password", onPressed: () {}),
                        SquareArrowButton(
                            text: "Booking History", onPressed: () {}),
                      ]),
                      Expanded(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(bottom: Sizes.paddingBig),
                            child: SizedBox(
                                width: double.infinity,
                                child: PrimaryButton(
                                    text: "Become a landlord",
                                    onPressed: () {})),
                          )
                        ],
                      ))
                    ]))));
  }
}
