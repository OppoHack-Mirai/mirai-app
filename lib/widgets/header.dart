import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  const Header({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(255, 0, 78, 181),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 35.0, horizontal: 30.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text(
              "Oct 23, 2022",
              style: TextStyle(color: Colors.white, fontSize: 16.0),
            ),
            Text(
              title,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold),
            )
          ]),
        ),
      ),
    );
  }
}
