import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';

import '../profile.dart';
import '../return_hom.dart';
import 'welcome.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreen();
}

class _LoginScreen extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  Profile profile = Profile(
    email: '',
    password: '',
  );
  final Future<FirebaseApp> firebase = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: firebase,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Error'),
            ),
            body: Center(
              child: Text('${snapshot.error}'),
            ),
          );
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return Scaffold(
            appBar: AppBar(
              title: Row(
                children: [
                  InkWell(
                    onTap: () {
                      returnHome(context);
                    },
                    child: const Padding(
                      padding: EdgeInsets.only(right: 9),
                      child: 
                        Icon(Icons.home, size: 30),
                    ),
                  ),
                  const Text('Login'),
                ],
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Email',
                        style: TextStyle(fontSize: 20),
                      ),
                      TextFormField(
                        validator: MultiValidator([
                          RequiredValidator(
                              errorText: 'Email cannot be empty!!'),
                          EmailValidator(errorText: 'Email format incorrect!!')
                        ]),
                        keyboardType: TextInputType.emailAddress,
                        onSaved: (String? email) {
                          profile.email = email!;
                        },
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      const Text(
                        'Password',
                        style: TextStyle(fontSize: 20),
                      ),
                      TextFormField(
                        validator: RequiredValidator(
                            errorText: 'Password cannot be empty!!'),
                        obscureText: true,
                        onSaved: (String? password) {
                          profile.password = password!;
                        },
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (formKey.currentState!.validate()) {
                              formKey.currentState?.save();
                              try {
                                await FirebaseAuth.instance
                                    .signInWithEmailAndPassword(
                                        email: profile.email,
                                        password: profile.password)
                                    .then((value) {
                                  formKey.currentState?.reset();
                                  goWelcomeScreen(context);
                                });
                              } on FirebaseAuthException catch (e) {
                                Fluttertoast.showToast(
                                    msg: e.message.toString(),
                                    gravity: ToastGravity.CENTER);
                              }
                            }
                          },
                          child: const Text(
                            'Login',
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }

  void goWelcomeScreen(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) {
        return WelcomeScreen();
      }),
    );
  }
}
