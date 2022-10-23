import 'package:flutter/material.dart';
import 'package:mirai_app/classes/mirai_user.dart';
import 'package:mirai_app/classes/smart_device.dart';
import 'package:mirai_app/widgets/header.dart';
import 'package:mirai_app/widgets/smart_card.dart';

class SmartHome extends StatefulWidget {
  const SmartHome({super.key, this.user});

  final MiraiUser? user;

  @override
  State<SmartHome> createState() => _SmartHomeState();
}

class _SmartHomeState extends State<SmartHome> {
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
            children: const [
              Header(title: "Smart Home"),
              SizedBox(
                height: 20,
              ),
              SmartCard(smartDevice: SmartDevice(image: "assets/oppowatch.png", name: "Haroon's Watch", location: "On Haroon's Wrist", status: false),),
              SmartCard(smartDevice: SmartDevice(image: "assets/opporouter.png", name: "My Router", location: "Behind the TV", status: true),),
              SmartCard(smartDevice: SmartDevice(image: "assets/oppotv.png", name: "Haroon's TV", location: "In the Bedroom", status: false),)
            ],
          ),
        ),
      ),
    );
  }
}