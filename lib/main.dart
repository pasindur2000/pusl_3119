import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pusl_3119/ui/onboarding_screen.dart';
import 'scan_page.dart';

void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget {


  @override
  Widget build(BuildContext context) {

    bool showOnboarding = true;

    return MaterialApp(
      title: 'Onboarding Screen',
      debugShowCheckedModeBanner: false,
      home: showOnboarding ? OnboardingScreen() : ScanPage(),
    );
  }
}
