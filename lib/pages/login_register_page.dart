import 'package:flutter/material.dart';
import 'package:bnbscout24/api/login_manager.dart';
import 'package:provider/provider.dart';
import 'package:bnbscout24/components/login_register_form.dart';
import 'package:bnbscout24/utils/snackbar_service.dart';

class LoginRegisterPage extends StatefulWidget {
  bool isLogin;

  LoginRegisterPage({super.key, this.isLogin = true});

  @override
  State<LoginRegisterPage> createState() => _LoginRegisterPageState();
}

class _LoginRegisterPageState extends State<LoginRegisterPage> {
  @override
  Widget build(BuildContext context) {
    final loginManager = Provider.of<LoginManager>(context);

    return widget.isLogin
        ? LoginRegisterForm(
            buttonText: "Sign In",
            onSubmit: (email, password, _, __) {
              loginManager.login(email, password);
            },
            linkText: "Or Sign Up here",
            onLinkButton: () {
              setState(() {
                widget.isLogin = false;
              });
            },
          )
        : LoginRegisterForm(
            buttonText: "Sign Up",
            showExtraFields: true,
            onSubmit: (email, password, confirmPassword, name) {
              if (password != confirmPassword) {
                return SnackbarService.showError(
                    'Passwords should be matching.');
              }
              loginManager.register(email, password, name);
            },
            linkText: "Or Sign In here",
            onLinkButton: () {
              setState(() {
                widget.isLogin = true;
              });
            },
          );
  }
}
