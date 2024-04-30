import 'dart:async';

import 'package:flutter/material.dart';
import 'package:users_noflie_foodpanda_clone/authentication/user_homescreen.dart';

import '../authentication/auth_screen.dart';
import '../global_variable/global.dart';


class UsersSplashScreen extends StatefulWidget {
  const UsersSplashScreen({super.key});

  @override
  State<UsersSplashScreen> createState() => _UsersSplashScreen();
}

class _UsersSplashScreen extends State<UsersSplashScreen> {
  startTimer() {
    Timer(const Duration(seconds: 4), () async {
    if (firebaseAuth.currentUser != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const UsersHomeScreen(),
          ),
        );
      } else {
        Navigator.push(context,
          MaterialPageRoute(builder: (context) => const AuthScreen()),
        );
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.green,
                Colors.blue,
              ],
              begin: AlignmentDirectional(0.0, 0.0),
              end: FractionalOffset(1.0, 0.0),

            )
          ),
         // color: Colors.white24,
          child: Center(
            child: Column(
              //crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('images/welcome.png'),
                const SizedBox(
                  height: 10,
                ),
                const Padding(
                  padding: EdgeInsets.all(18.0),
                  child: Text(
                    "Order food onlie with Noflie App",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontFamily: "Train",
                      letterSpacing: 3,
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
}
