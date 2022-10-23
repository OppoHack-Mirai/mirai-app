import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:mirai_app/classes/smart_device.dart';
import 'package:mirai_app/styles/smart_card.dart';

class SmartCard extends StatelessWidget {
  const SmartCard({super.key, required this.smartDevice});

  final SmartDevice smartDevice;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 150.0,
        margin: const EdgeInsets.symmetric(
          vertical: 16.0,
          horizontal: 24.0,
        ),
        child: Stack(
          children: <Widget>[
            Container(
              height: 154.0,
              margin: const EdgeInsets.only(left: 46.0),
              decoration: BoxDecoration(
                color:
                    const Color.fromARGB(255, 39, 58, 83), // Color(0xFF333366)
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: const <BoxShadow>[
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10.0,
                    offset: Offset(0.0, 10.0),
                  ),
                ],
              ),
              child: Container(
                margin: const EdgeInsets.fromLTRB(76.0, 16.0, 16.0, 16.0),
                constraints: const BoxConstraints.expand(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(height: 4.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          smartDevice.name ?? "",
                          style: headerTextStyle,
                        ),
                        Container(
                          height: 12,
                          width: 12,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: smartDevice.status ?? true
                                ? Colors.green
                                : Colors.red,
                          ),
                        ),
                      ],
                    ),
                    Container(height: 10.0),
                    Text(smartDevice.location ?? "", style: subHeaderTextStyle),
                    Container(
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        height: 2.0,
                        width: 18.0,
                        color: const Color(0xff00c6ff)),
                    ElevatedButton(onPressed: () {}, child: const Text("Manage Device",)),
                  ],
                ),
              ),
            ),
            Container(
                margin: const EdgeInsets.symmetric(vertical: 16.0),
                alignment: FractionalOffset.centerLeft,
                child: Image(
                  image: AssetImage(smartDevice.image ?? ""),
                  height: 92.0,
                  width: 92.0,
                )),
          ],
        ));
  }
}
