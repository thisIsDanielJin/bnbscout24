import 'package:flutter/material.dart';
import 'package:bnbscout24/components/button.dart';
import 'package:bnbscout24/constants/sizes.dart';
import 'package:bnbscout24/constants/constants.dart';
import 'package:bnbscout24/components/custom_text_input.dart';

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
                'bnb',
                style: TextStyle(
                    color: ColorPalette.primary,
                    fontWeight: FontWeight.normal,
                    fontSize: 30),
              ),
              Text(
                'scout',
                style: TextStyle(
                    color: ColorPalette.darkGrey,
                    fontWeight: FontWeight.bold,
                    fontSize: 30),
              ),
              Text(
                '24',
                style: TextStyle(
                    color: ColorPalette.primary,
                    fontWeight: FontWeight.normal,
                    fontSize: 30),
              )
            ]),
            SizedBox(height: Sizes.paddingBig),
            CustomTextInput(controller: emailController, hint: 'Enter email'),
            if (showExtraFields)
              Column(children: [
                SizedBox(height: Sizes.paddingRegular),
                CustomTextInput(controller: nameController, hint: 'Enter name')
              ]),
            SizedBox(height: Sizes.paddingRegular),
            CustomTextInput(
                controller: passwordController,
                hint: 'Enter password',
                obscureText: true),
            if (showExtraFields)
              Column(children: [
                SizedBox(height: Sizes.paddingRegular),
                CustomTextInput(
                    controller: confirmPasswordController,
                    hint: 'Confirm password',
                    obscureText: true),
              ]),
            SizedBox(height: Sizes.paddingBig),
            SizedBox(
              width: double.infinity,
              child: ColorButton(
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
