import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:mirai_app/classes/mirai_user.dart';
import 'package:mirai_app/pages.dart';
import 'package:mirai_app/pages/authenticate.dart';
import 'package:mirai_app/pages/login.dart';
import 'firebase_options.dart';
import 'package:mirai_app/globals.dart' as globals;

class Authorization extends StatefulWidget {
  const Authorization({super.key});

  @override
  State<Authorization> createState() => _AuthorizationState();
}

class _AuthorizationState extends State<Authorization> {
  @override
  void initState() {
    FlutterNativeSplash.remove();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire
      future: Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ),
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return const Scaffold(
            body: CircularProgressIndicator(),
          );
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (BuildContext context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data == null) {
                  return const Authenticate();
                }
                var db = FirebaseFirestore.instance;
                final ref = db
                    .collection("users")
                    .doc(snapshot.data?.uid)
                    .withConverter(
                      fromFirestore: MiraiUser.fromFirestore,
                      toFirestore: (MiraiUser user, _) => user.toFirestore(),
                    );
                User? user = snapshot.data;
                return FutureBuilder(
                    future: ref.get(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        if(snapshot.hasData) {
                          MiraiUser? miraiUser = snapshot.data?.data();
                          if(miraiUser == null) {
                            final data = {
                              "time": Timestamp.now(),
                              "name": user?.displayName,
                              "email": user?.email,
                              "type": globals.type,
                              "files": [],
                              "earnings": 0,
                              "earningsYearly": 0,
                              "nodes_running": 0,
                              "dead_nodes": 0,
                              "nodes": [] 
                            };
                            db.collection("users").doc(user?.uid).set(data);
                            return Pages(miraiUser: MiraiUser(user, 0, 0, 0, [], [], 0, Timestamp.now(), globals.type),);
                          }
                          miraiUser.user = user;
                          return Pages(miraiUser: miraiUser);
                        }
                      }

                      return const Authenticate();
                    });
              } else {
                return const Authenticate();
              }
            },
          );
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return const Scaffold(
          body: CircularProgressIndicator(),
        );
      },
    );
  }
}
