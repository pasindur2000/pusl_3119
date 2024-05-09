import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pano1/constants.dart';
import 'package:pano1/ui/root_page.dart';
import 'package:pano1/ui/screens/forgot_password.dart';
import 'package:pano1/ui/screens/signup_page.dart';
import 'package:pano1/ui/screens/widgets/custom_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _LoginState();
}

class _LoginState extends State<SignIn> {
  final _auth = FirebaseAuth.instance;
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                child: Image.asset('assets/images/signin.png'),
              ),
              const Text(
                'Sign In',
                style: TextStyle(
                  fontSize: 35.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              TextField(
                onChanged: (value) {
                  email = value;
                },
                keyboardType: TextInputType.emailAddress,
                obscureText: false,
                decoration: const InputDecoration(
                  hintText: 'Enter Email',
                  prefixIcon: Icon(Icons.alternate_email),
                ),
              ),
              TextField(
                onChanged: (value) {
                  password = value;
                },
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: 'Enter Password',
                  prefixIcon: Icon(Icons.lock),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () async {
                  try {
                    final user = await _auth.signInWithEmailAndPassword(
                        email: email, password: password);
                    if (user != null) {
                      Navigator.pushReplacement(
                          context,
                          PageTransition(
                              child: const RootPage(),
                              type: PageTransitionType.bottomToTop));
                    }
                  }
                  catch (e) {
                    print(e);
                  }
                },
                child: Container(
                  width: size.width,
                  decoration: BoxDecoration(
                    color: Constants.primaryColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  child: const Center(
                    child: Text(
                      'Sign In',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                      context,
                      PageTransition(
                          child: const ForgotPassword(),
                          type: PageTransitionType.bottomToTop));
                },
                child: Center(
                  child: Text.rich(TextSpan(children: [
                    TextSpan(
                      text: 'Forgot Password?',
                      style: TextStyle(
                        color: Constants.blackColor,
                      ),
                    ),
                    TextSpan(
                      text: 'Reset Here',
                      style: TextStyle(
                        color: Constants.primaryColor,
                      ),
                    ),
                  ])),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: const [
                  Expanded(child: Divider()),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text('OR'),
                  ),
                  Expanded(child: Divider()),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: _handleGoogleSignIn,
                child: Container(
                width: size.width,
                decoration: BoxDecoration(
                    border: Border.all(color: Constants.primaryColor),
                    borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                      height: 30,
                      child: Image.asset('assets/images/google.png'),
                    ),
                    Text(
                      'Sign In with Google',
                      style: TextStyle(
                        color: Constants.blackColor,
                        fontSize: 18.0,

                      ),
                    ),
                  ],
                ),
              ),
              ),
              const SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                      context,
                      PageTransition(
                          child: const RootPage(),
                          type: PageTransitionType.bottomToTop));
                },
                child: Center(
                  child: Text.rich(TextSpan(children: [
                    TextSpan(
                      text: 'New to Disector?',
                      style: TextStyle(
                        color: Constants.blackColor,
                      ),
                    ),
                    TextSpan(
                      text: 'Register',
                      style: TextStyle(
                        color: Constants.primaryColor,
                      ),
                    ),
                  ])),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Center(
                child: GestureDetector(
                  onTap: (){},
                  child: Container(
                    width: 250,
                    decoration: BoxDecoration(
                      color: Color(0xff475965),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: const Center(
                      child: Text(
                        'Agriculture Professional',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                  ),
                ),
              )


            ],
          ),
        ),
      ),
    );
  }

  void _handleGoogleSignIn() async {
    try{
       GoogleSignIn googleSignIn = GoogleSignIn();
       GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
       if (googleSignInAccount != null){
         GoogleSignInAuthentication googleSignInAuthentication =
             await googleSignInAccount.authentication;
         AuthCredential credential = GoogleAuthProvider.credential(
           accessToken: googleSignInAuthentication.accessToken,
           idToken: googleSignInAuthentication.idToken,
         );
         UserCredential userCredential =
             await FirebaseAuth.instance.signInWithCredential(credential);
         if (userCredential.user != null) {
           Navigator.pushReplacement(
               context,
             PageTransition(
                 child: const RootPage(),
                 type: PageTransitionType.bottomToTop,
             ),
           );
         }
       }
    }catch(error){
      print(error);
    }
  }

}
