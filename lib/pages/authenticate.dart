import 'package:flutter/material.dart';
import 'package:mirai_app/pages/login.dart';
import 'package:mirai_app/pages/signup.dart';

class Authenticate extends StatefulWidget {
  const Authenticate({super.key});

  @override
  State<Authenticate> createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {

  bool sign = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: sign ? Signup(callback: () {
        setState(() {
          sign = !sign;
        });
      },) : Login(callback: () {
        setState(() {
          sign = !sign;
        });
      },),
    );
  }
}