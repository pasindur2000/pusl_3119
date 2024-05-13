import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pano1/ui/onboarding_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'scan_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Use a bool or other condition to determine the initial screen
    bool showOnboarding = true;

    return const MaterialApp(
      title: 'My App',
      home: OnboardingScreen(),
      debugShowCheckedModeBanner: false
    );
  }
}
