import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mirai_app/classes/google_sign_in.dart';

class Login extends StatefulWidget {
  const Login({super.key, required this.callback});

  final Function callback;

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isObscure = true;

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
                          child: Text('Log Into Your \nMiraiDB Account',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 30.0,
                                  fontWeight: FontWeight.w600))),
                      const SizedBox(
                        height: 20.0,
                      ),
                      const Text(
                        'Use your MiraiDB Account',
                        style: TextStyle(
                            color: Color(0xFF696969),
                            fontSize: 19.0,
                            fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(
                        height: 50.0,
                      ),
                      const Text(
                        'Log In',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 22.0),
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
                        height: 30.0,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              try {
                                await FirebaseAuth.instance
                                    .signInWithEmailAndPassword(
                                        email: _emailController.text,
                                        password: _passwordController.text);
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
                              'Log In',
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
                                  'Sign In with Google',
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
                            'Don\'t have an account?',
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
                                'Sign Up',
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
