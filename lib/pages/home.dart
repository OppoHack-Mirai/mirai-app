import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mirai_app/widgets/header.dart';
import 'package:mirai_app/widgets/ply_button.dart';
import '../classes/mirai_user.dart';

class Home extends StatefulWidget {
  const Home({super.key, this.user});

  final MiraiUser? user;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool srvState = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        color: const Color.fromARGB(255, 237, 237, 237),
        child: ConstrainedBox(
          constraints:
              BoxConstraints(minHeight: MediaQuery.of(context).size.height),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Header(title: "MiraiDB"),
              SizedBox(
                height: Platform.isAndroid ? 120 : 180,
              ),
              SizedBox(
                  height: 200,
                  width: 200,
                  child: PlayButton(
                    pauseIcon: const Icon(Icons.power_settings_new_rounded,
                        color: Colors.green, size: 90),
                    playIcon: const Icon(Icons.power_settings_new_rounded,
                        color: Colors.red, size: 90),
                    onPressed: () {
                      setState(() {
                        srvState = !srvState;
                      });
                    },
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
