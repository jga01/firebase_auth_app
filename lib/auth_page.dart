import 'package:firebase_auth_app/login_widget.dart';
import 'package:firebase_auth_app/signup_widget.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool isLogin = true;

  @override
  Widget build(BuildContext context) => isLogin
      ? LoginWidget(onClickedSignup: toggle)
      : SignUpWidget(onClickedSignup: toggle);

  void toggle() => setState(() => isLogin = !isLogin);
}
