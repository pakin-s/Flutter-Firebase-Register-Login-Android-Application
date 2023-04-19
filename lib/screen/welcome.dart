import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../return_hom.dart';

class WelcomeScreen extends StatelessWidget {
  WelcomeScreen({super.key});

  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Welcome')),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: Column(
            children: [
              Text(
                auth.currentUser!.email.toString(),
                style: const TextStyle(fontSize: 25),
              ),
              ElevatedButton(
                child: const Text('Logout'),
                onPressed: () {
                  auth.signOut().then((value) {
                    returnHome(context);
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
