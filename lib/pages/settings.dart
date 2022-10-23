import 'package:flutter/material.dart';
import 'package:mirai_app/classes/mirai_user.dart';
import 'package:mirai_app/widgets/header.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Settings extends StatefulWidget {
  const Settings({super.key, this.user});

  final MiraiUser? user;

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
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
              const Header(title: "Settings"),
              const SizedBox(
                height: 20,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Compute Resources', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),),
                    const SizedBox(height: 10,),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.white,
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        children: [
                          ListTile(
                            title: const Text('CPU Usage'),
                            leading: const Icon(Icons.bolt_rounded),
                            trailing: const Icon(CupertinoIcons.chevron_forward),
                            onTap: () async {
                              
                            },
                          ),
                          const Divider(color: Colors.black54,),
                          ListTile(
                            title: const Text('Storage'),
                            leading: const Icon(Icons.storage_rounded),
                            trailing: const Icon(CupertinoIcons.chevron_forward),
                            onTap: () async {
                                
                            },
                          ),
                          const Divider(color: Colors.black54,),
                          ListTile(
                            title: const Text('Services'),
                            leading: const Icon(Icons.electrical_services_rounded),
                            trailing: const Icon(CupertinoIcons.chevron_forward),
                            onTap: () async {
                                
                            },
                          ),
                          const Divider(color: Colors.black54,),
                          ListTile(
                            title: const Text('Protocols'),
                            leading: const Icon(Icons.wifi_rounded),
                            trailing: const Icon(CupertinoIcons.chevron_forward),
                            onTap: () async {
                                
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20,),
                    const Text('Billing', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),),
                    const SizedBox(height: 10,),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.white,
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        children: [
                          ListTile(
                            title: const Text('Billing Info'),
                            leading: const Icon(Icons.info_rounded),
                            trailing: const Icon(CupertinoIcons.chevron_forward),
                            onTap: () {
                              
                            },
                          ),
                          const Divider(color: Colors.black54,),
                          ListTile(
                            title: const Text('Payment Method'),
                            leading: const Icon(Icons.account_balance_rounded),
                            trailing: const Icon(CupertinoIcons.chevron_forward),
                            onTap: () async {
                              
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20,),
                    const Text('Account', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),),
                    const SizedBox(height: 10,),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.white,
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        children: [
                          ListTile(
                            title: const Text('Account info'),
                            leading: const Icon(Icons.person_rounded),
                            trailing: const Icon(CupertinoIcons.chevron_forward),
                            onTap: () {
                              
                            },
                          ),
                          const Divider(color: Colors.black54,),
                          ListTile(
                            title: const Text('Log out'),
                            leading: const Icon(Icons.logout_rounded),
                            trailing: const Icon(CupertinoIcons.chevron_forward),
                            onTap: () async {
                              await FirebaseAuth.instance.signOut();
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 50,)
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );;
  }
}