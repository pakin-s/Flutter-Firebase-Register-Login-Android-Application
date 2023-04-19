import 'package:flutter/material.dart';

import 'screen/home.dart';

void returnHome(BuildContext context) {
    Navigator.pushReplacement(context, 
      MaterialPageRoute(builder: (context) {
        return const HomeScreen();
      }),
    );
  }