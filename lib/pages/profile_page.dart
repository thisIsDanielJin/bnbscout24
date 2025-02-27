import 'package:bnbscout24/pages/booking_history.dart';
import 'package:flutter/material.dart';
import 'package:bnbscout24/constants/sizes.dart';
import 'package:bnbscout24/components/button.dart';
import 'package:bnbscout24/api/login_manager.dart';
import 'package:provider/provider.dart';
import 'package:bnbscout24/pages/change_password_page.dart';
import 'package:bnbscout24/pages/user_info_page.dart';

import '../components/page_base.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final loginManager = Provider.of<LoginManager>(context);

    return PageBase(
                title: "Profile Settings",
                child: Column(
                  spacing: Sizes.paddingRegular,
                    children: [
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
                            text: "Booking History",
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => BookingHistory()),
                              );
                            }),
                        SquareArrowButton(
                            text: "Logout",
                            onPressed: () => loginManager.logout()),

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
                                      child: ColorButton(
                                          text: "Become a landlord",
                                          onPressed: () =>
                                              LoginManager.doLandlordUpgrade())),
                                )
                              ],
                            ))
                    ]),

                    );
  }
}
