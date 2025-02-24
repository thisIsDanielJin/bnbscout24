import 'package:bnbscout24/utils/snackbar_service.dart';
import 'package:flutter/material.dart';
import 'package:bnbscout24/constants/sizes.dart';
import 'package:bnbscout24/components/button.dart';
import 'package:bnbscout24/api/login_manager.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: Container(
                padding: EdgeInsets.all(Sizes.paddingRegular),
                child: Column(children: [
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
                  Column(spacing: Sizes.paddingRegular, children: [
                    TextField(
                      controller: oldPasswordController,
                      decoration: InputDecoration(
                        hintText: 'Enter Old Password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                      ),
                      obscureText: true,
                    ),
                    TextField(
                      controller: passwordController,
                      decoration: InputDecoration(
                        hintText: 'Enter New Password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                      ),
                      obscureText: true,
                    ),
                    TextField(
                      controller: confirmPasswordController,
                      decoration: InputDecoration(
                        hintText: 'Confirm New Password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                      ),
                      obscureText: true,
                    ),
                    SizedBox(
                        width: double.infinity,
                        child: PrimaryButton(
                            text: "Change Password",
                            onPressed: () {
                              if (passwordController.text !=
                                  confirmPasswordController.text) {
                                return SnackbarService.showError(
                                    'Passwords should be matching.');
                              }
                              LoginManager.changePassword(
                                  oldPasswordController.text,
                                  passwordController.text,
                                  successCallback: () =>
                                      Navigator.pop(context));
                            })),
                  ]),
                ]))));
  }
}
