import 'package:flutter/material.dart';
import 'package:mirai_app/pages/home.dart';
import 'package:mirai_app/pages/home_user.dart';
import 'package:mirai_app/pages/money.dart';
import 'package:mirai_app/pages/files.dart';
import 'package:mirai_app/pages/settings.dart';
import 'package:mirai_app/pages/settings_user.dart';
import 'package:mirai_app/pages/smarthome.dart';

import 'classes/mirai_user.dart';

class Pages extends StatefulWidget {
  const Pages({super.key, this.miraiUser});

  final MiraiUser? miraiUser;

  @override
  State<Pages> createState() => _PagesState();
}

class _PagesState extends State<Pages> {

  int currentIndex = 0;

  Widget _pages(page) {
    if(widget.miraiUser?.type == "Admin") {
      if(page == 0) {
        return Home(user: widget.miraiUser,);
      } else if(page == 1) {
        return Files(user: widget.miraiUser,);
      } else if(page == 2) {
        return Money(user: widget.miraiUser,);
      } else if(page == 3) {
        return SmartHome(user: widget.miraiUser,);
      } else {
        return Settings(user: widget.miraiUser,);
      }
    } else {
      if(page == 0) {
        return HomeUser(user: widget.miraiUser,);
      } else if(page == 1) {
        return Files(user: widget.miraiUser,);
      } else {
        return SettingsUser(user: widget.miraiUser,);
      }
    }
  }

  @override
  void initState() {
    
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages(currentIndex),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.black,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: ((value) {
          setState(() {
            currentIndex = value;
          });
        }),
        items: widget.miraiUser?.type == "Admin" ? const [
          BottomNavigationBarItem(icon: Icon(Icons.home_mini), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.list_rounded), label: 'Files'),
          BottomNavigationBarItem(icon: Icon(Icons.wallet_rounded), label: 'Money'),
          BottomNavigationBarItem(icon: Icon(Icons.device_hub_rounded), label: 'Smart Home'),
          BottomNavigationBarItem(icon: Icon(Icons.settings_rounded), label: 'Settings')
        ] : const [
          BottomNavigationBarItem(icon: Icon(Icons.home_mini), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.list_rounded), label: 'Files'),
          BottomNavigationBarItem(icon: Icon(Icons.settings_rounded), label: 'Settings')
        ],
      ),
    );
  }
}