import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mirai_app/classes/google_sign_in.dart';
import 'package:mirai_app/classes/validator.dart';
import 'package:mirai_app/globals.dart' as globals;

class Signup extends StatefulWidget {
  const Signup({super.key, required this.callback});

  final Function callback;

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _displayNameController = TextEditingController();
  bool _isObscure = true;
  String? selectedValue = "User";
  var db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
          key: _formKey,
          child: Column(children: [
            Container(
              width: double.infinity,
              color: const Color(0xFF004EB5),
              child: Padding(
                padding: const EdgeInsets.all(40),
                child: Image.asset(
                  'assets/MiraiDB-large.png',
                  height: 200,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                      width: double.infinity,
                      child: Text('Create Your \nMiraiDB Account',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 30.0,
                              fontWeight: FontWeight.w600))),
                  const SizedBox(
                    height: 20.0,
                  ),
                  const Text(
                    'Get started today!',
                    style: TextStyle(
                        color: Color(0xFF696969),
                        fontSize: 19.0,
                        fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(
                    height: 50.0,
                  ),
                  const Text(
                    'Create Account',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 22.0),
                  ),
                  const SizedBox(
                    height: 17.0,
                  ),
                  TextFormField(
                    controller: _displayNameController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Name',
                      prefixIcon: Icon(
                        Icons.person_outline,
                        size: 30.0,
                      ),
                    ),
                    validator: (value) => Validator.validateName(name: value),
                  ),
                  const SizedBox(
                    height: 17.0,
                  ),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Email',
                      prefixIcon: Icon(
                        Icons.email,
                        size: 30.0,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 17.0,
                  ),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _isObscure,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      hintText: 'Password',
                      prefixIcon: const Icon(
                        Icons.lock,
                        size: 30.0,
                      ),
                      suffixIcon: IconButton(
                          icon: Icon(_isObscure
                              ? Icons.visibility_off
                              : Icons.visibility),
                          onPressed: () {
                            setState(() {
                              _isObscure = !_isObscure;
                            });
                          }),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a password';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 17.0,
                  ),
                  InputDecorator(
                    decoration:
                        const InputDecoration(border: OutlineInputBorder()),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton(
                          isExpanded: true,
                          onChanged: (value) {
                            setState(() {
                              selectedValue = value;
                            });
                          },
                          value: selectedValue,
                          items: const [
                            DropdownMenuItem(
                              value: "Admin",
                              child: Text("Admin"),
                            ),
                            DropdownMenuItem(value: "User", child: Text("User"))
                          ]),
                    ),
                  ),
                  const SizedBox(
                    height: 30.0,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          try {
                            UserCredential user = await FirebaseAuth.instance
                                .createUserWithEmailAndPassword(
                                    email: _emailController.text,
                                    password: _passwordController.text);
                            final data = {
                              "time": Timestamp.now(),
                              "name": _displayNameController.text,
                              "email": user.user?.email,
                              "type": selectedValue,
                              "files": [],
                              "earnings": 0,
                              "earningsYearly": 0,
                              "nodes_running": 0,
                              "dead_nodes": 0,
                              "nodes": [] 
                            };
                            db.collection("users").doc(user.user?.uid).set(data);
                          } on FirebaseAuthException catch (e) {
                            if (e.code == 'user-not-found') {
                              throw ('No user found for that email.');
                            } else if (e.code == 'wrong-password') {
                              throw ('Wrong password provided for that user.');
                            }
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColorDark,
                      ),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 15.0, horizontal: 8.0),
                        child: Text(
                          'Sign Up',
                          style: TextStyle(fontSize: 17.0),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
                  Row(children: const <Widget>[
                    Expanded(
                        child: Padding(
                      padding: EdgeInsets.only(right: 15),
                      child: Divider(
                        color: Colors.black,
                      ),
                    )),
                    Text("OR"),
                    Expanded(
                        child: Padding(
                      padding: EdgeInsets.only(left: 15),
                      child: Divider(
                        color: Colors.black,
                      ),
                    )),
                  ]),
                  const SizedBox(
                    height: 15.0,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        globals.type = selectedValue;
                        final provider = GoogleSignInProvider();
                        await provider.googleLogin();
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFFFFFF),
                          elevation: 0.0,
                          side: const BorderSide(
                              width: 2.0,
                              color: Color.fromARGB(255, 247, 44, 44))),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 15.0, horizontal: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            FaIcon(
                              FontAwesomeIcons.google,
                              color: Color.fromARGB(255, 247, 44, 44),
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                            Text(
                              'Sign Up with Google',
                              style: TextStyle(
                                  fontSize: 17.0,
                                  color: Color.fromARGB(255, 247, 44, 44)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Already have an account?',
                        style: TextStyle(
                            color: Color(0xFF808080),
                            fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(
                        width: 5.0,
                      ),
                      InkWell(
                          onTap: () {
                            widget.callback();
                          },
                          child: Text(
                            'Log In',
                            style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 17.0),
                          ))
                    ],
                  ),
                  const SizedBox(
                    height: 50.0,
                  ),
                ],
              ),
            )
          ])),
    );
  }
}
