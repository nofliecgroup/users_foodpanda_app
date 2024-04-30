import 'package:flutter/material.dart';
import 'package:users_noflie_foodpanda_clone/authentication/login.dart';

import '../global_variable/global.dart';

class UsersHomeScreen extends StatefulWidget {
  const UsersHomeScreen({super.key});

  @override
  State<UsersHomeScreen> createState() => _UsersHomeScreenState();
}

class _UsersHomeScreenState extends State<UsersHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 3.0,
          title: Text(sharedPreferences!.getString("name")!),
          centerTitle: true,
          automaticallyImplyLeading: false,
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
        ),
        body: Center(
          child: ElevatedButton(
              onPressed: () {
                firebaseAuth.signOut().then((value) {
                  Navigator.push(context, MaterialPageRoute(builder: (c) => const UsersLogin()));
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.cyan,
              ),
              child: const Text("Logout")
          ),
        )
    );
  }
}
