
import 'package:expense_manager/MYHOME.dart';
import 'package:expense_manager/session.dart';
import 'package:expense_manager/signin_screen.dart';

import 'package:flutter/material.dart';


class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  void navigate(BuildContext context) {
    Future.delayed(const Duration(seconds: 3), () async {
      bool status=false;

      await SessionData.getSessionData();

      if(SessionData.isLogin!){
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)
        {
          return MyHomePage(email:SessionData.emailId!,);
        }
        ));
      }
      else{
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)
        {
          return SignInScreen();
        }
        ));
      }
      // Navigator.of(context).pushReplacement(
      //   MaterialPageRoute(
      //     builder: (context) {
      //       return const WelcomeScreen();
      //     },
      //   ),
      // );
    }
    );
  }

  @override
  Widget build(BuildContext context) {
    navigate(context);
    return Scaffold(
    backgroundColor: Colors.black,
      body: Center(
          child: Stack(
        children: [
          // SizedBox(
          //   width: MediaQuery.of(context).size.width,
          //   height: MediaQuery.of(context).size.height,
          //   child: Image.asset("assets/images/background.jpg"),
          // ),
          Center(
            child: SizedBox(
              width: 250,
              height: 250,
              child: Image.asset("assets/images/logo.jpeg"),
            ),
          ),
        ],
      )),
    );
  }
}