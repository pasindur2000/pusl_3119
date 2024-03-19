
import 'package:flutter/material.dart';
import 'package:pusl_3119/constants.dart';


class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _LoginState();
}

class _LoginState extends State<SignIn> {
  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset('assets/images/signin.png'),
            const Text('Sign In', style: TextStyle(
              fontSize: 35.0,
              fontWeight: FontWeight.w700,
            ),)
          ],
        ),
      ),
    );
  }
}
