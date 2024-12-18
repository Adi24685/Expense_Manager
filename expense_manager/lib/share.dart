import 'package:expense_manager/Home_page.dart';
import 'package:expense_manager/MYHOME.dart';
import 'package:expense_manager/session.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});
  void navigate(BuildContext context) {
    Future.delayed(
      const Duration(seconds: 3),
      () async {
        bool status = false;

        await SessionData.getSessionData();

        print("IS LOGIN : ${SessionData.isLogin}");

        if (SessionData.isLogin!) {
          print("NAVIGATE TO HOME");
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) {
                return MyHomePage(
                  email: SessionData.emailId!,
                );
              },
            ),
          );
        } else {
          print("NAVIGATE TO LOGIN");
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) {
                return Home_Page();
              },
            ),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    print("IN BUILD");
    navigate(context);
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 250,
          height: 250,
          child: Image.network(""),
        ),
      ),
    );
  }
}