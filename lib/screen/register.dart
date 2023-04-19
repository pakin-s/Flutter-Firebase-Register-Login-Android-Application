import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:login_system/profile.dart';
import 'package:form_field_validator/form_field_validator.dart';

import '../return_hom.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
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
                  const Text('Create User'),
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
                                    .createUserWithEmailAndPassword(
                                  email: profile.email,
                                  password: profile.password,
                                ).then((value) {
                                  formKey.currentState?.reset();
                                  Fluttertoast.showToast(
                                    msg: 'Create User Success',
                                    gravity: ToastGravity.TOP
                                  );
                                // ignore: use_build_context_synchronously
                                  returnHome(context);
                                });
                              } on FirebaseAuthException catch (e) {
                                Fluttertoast.showToast(
                                  msg: e.message.toString(),
                                  gravity: ToastGravity.CENTER
                                );
                              }
                            }
                          },
                          child: const Text(
                            'Register',
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
}
