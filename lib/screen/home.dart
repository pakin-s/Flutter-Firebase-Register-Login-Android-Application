import 'package:flutter/material.dart';
import 'package:login_system/screen/login.dart';
import 'package:login_system/screen/register.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register/Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(40.0),
                child: Image.asset('assets/images/logo.png'),
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return const RegisterScreen();
                          },
                        ),
                      );
                    },
                    icon: const Icon(Icons.add),
                    label: const Text(
                      'Create User',
                      style: TextStyle(fontSize: 20),
                    )),
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                    onPressed: () {
                       Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return const LoginScreen();
                          },
                        ),
                      );
                    },
                    icon: const Icon(Icons.login),
                    label: const Text(
                      'Login',
                      style: TextStyle(fontSize: 20),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
