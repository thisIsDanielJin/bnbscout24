import 'package:flutter/material.dart';
import 'package:bnbscout24/components/button.dart';
import 'package:bnbscout24/constants/sizes.dart';
import 'package:bnbscout24/constants/constants.dart';

class LoginRegisterForm extends StatelessWidget {
  final String buttonText;
  final Function(
          String username, String password, String confirmPassword, String name)
      onSubmit;
  final String linkText;
  final VoidCallback onLinkButton;
  final bool showExtraFields;

  LoginRegisterForm({
    required this.buttonText,
    required this.onSubmit,
    required this.linkText,
    required this.onLinkButton,
    this.showExtraFields = false,
    Key? key,
  }) : super(key: key);

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return (SafeArea(
        child: Scaffold(
      body: Container(
        padding: EdgeInsets.all(Sizes.paddingRegular),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(
                'Re',
                style: TextStyle(
                    color: ColorPalette.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 30),
              ),
              Text(
                'vi',
                style: TextStyle(
                    color: ColorPalette.darkGrey,
                    fontWeight: FontWeight.normal,
                    fontSize: 30),
              ),
              Text(
                'tail',
                style: TextStyle(
                    color: ColorPalette.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 30),
              ),
              Text(
                'ize',
                style: TextStyle(
                    color: ColorPalette.darkGrey,
                    fontWeight: FontWeight.normal,
                    fontSize: 30),
              )
            ]),
            SizedBox(height: Sizes.paddingBig),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                hintText: 'Enter email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
            ),
            if (showExtraFields)
              Column(children: [
                SizedBox(height: Sizes.paddingRegular),
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    hintText: 'Enter name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                ),
              ]),
            SizedBox(height: Sizes.paddingRegular),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                hintText: 'Enter Password',
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
            if (showExtraFields)
              Column(children: [
                SizedBox(height: Sizes.paddingRegular),
                TextField(
                  controller: confirmPasswordController,
                  decoration: InputDecoration(
                    hintText: 'Confirm Password',
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
              ]),
            SizedBox(height: Sizes.paddingBig),
            SizedBox(
              width: double.infinity,
              child: PrimaryButton(
                  text: buttonText,
                  onPressed: () {
                    onSubmit(emailController.text, passwordController.text,
                        confirmPasswordController.text, nameController.text);
                  }),
            ),
            SizedBox(height: Sizes.paddingRegular),
            TextButton(
              onPressed: onLinkButton,
              child: Text(
                linkText,
                style: TextStyle(color: ColorPalette.darkGrey),
              ),
            )
          ],
        ),
      ),
    )));
  }
}
