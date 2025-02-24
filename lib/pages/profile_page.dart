import 'package:flutter/material.dart';
import 'package:bnbscout24/constants/sizes.dart';
import 'package:bnbscout24/components/button.dart';
import 'package:bnbscout24/api/login_manager.dart';
import 'package:provider/provider.dart';
import 'package:bnbscout24/pages/change_password_page.dart';
import 'package:bnbscout24/pages/user_info_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final loginManager = Provider.of<LoginManager>(context);

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
                            text: "User Information",
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const UserInformationPage(),
                                ),
                              );
                            }),
                        SquareArrowButton(
                            text: "Change Password",
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const ChangePasswordPage(),
                                ),
                              );
                            }),
                        SquareArrowButton(
                            text: "Booking History", onPressed: () {}),
                        SquareArrowButton(
                            text: "Logout",
                            onPressed: () => loginManager.logout()),
                      ]),
                      if (!loginManager.isLandlord)
                        Expanded(
                            child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Padding(
                              padding:
                                  EdgeInsets.only(bottom: Sizes.paddingBig),
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
