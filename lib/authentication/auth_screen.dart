import 'package:flutter/material.dart';
import 'package:users_noflie_foodpanda_clone/authentication/register.dart';

import 'login.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.blueAccent,
                  Colors.green,
                ],
                begin: FractionalOffset(0.0, 0.0),
                end: FractionalOffset(1.0, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.decal,
              ),
            ),
          ),
          automaticallyImplyLeading: false,
          title: const Text(
            "Food Rider App",
            style: TextStyle(
              fontSize: 35,
              color: Colors.white,
              fontFamily: "Lobster",
            ),
          ),
          centerTitle: true,
          bottom: const TabBar(
            tabs: [
              Tab(
                icon: Icon(
                  Icons.lock,
                  color: Colors.white,
                ),
                text: "Sign In",
                iconMargin: EdgeInsets.all(6.0),
              ),
              Tab(
                icon: Icon(
                  Icons.person,
                  color: Colors.white,
                ),
                text: "Register",
                iconMargin: EdgeInsets.all(6.0),
              ),
            ],
            indicatorColor: Colors.white38,
            indicatorWeight: 6,
          ),
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              // begin: Alignment.topRight,
              // end: Alignment.bottomLeft,
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
              colors: [
                Colors.blueAccent,
                Colors.green,
              ],
            ),
          ),
          child: const TabBarView(
            children: [
              UsersLogin(),
              UsersRegistration(),
            ],
          ),
        ),
      ),
    );
  }
}
