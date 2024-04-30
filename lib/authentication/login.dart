
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:users_noflie_foodpanda_clone/authentication/user_homescreen.dart';

import '../global_variable/global.dart';
import '../widgets/custom_textfield.dart';
import '../widgets/error_dialog.dart';
import '../widgets/loading_dialog.dart';
import 'auth_screen.dart';


class UsersLogin extends StatefulWidget {
  const UsersLogin({super.key});

  @override
  State<UsersLogin> createState() => _UsersLoginState();
}

class _UsersLoginState extends State<UsersLogin> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  forValidation() {
    if (_emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty) {
      // set login
      loginNow();

    } else {
      showDialog(
          context: context,
          builder: (context) {
            return const ErrorDialog(
                message:
                "Please provide a valid email/password to login! Try Again");
          });
      firebaseAuth.signOut();
    }
  }

  loginNow() async {
    showDialog(
        context: context,
        builder: (context) {
          return const LoadingDialog(
              message: "Login in progress, Checking credentials");
        });

    User? currentUser;
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim())
        .then((auth) {
      currentUser = auth.user!;
    }).catchError((error) {
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (context) {
            return ErrorDialog(
              message: error.message.toString(),
            );
          });
    });
    if (currentUser != null) {
      readDataAndSetDataLocally(currentUser!);
      //readDataAndSetDataLocally(currentUser!).then((value) {

      // Navigator.push(context, MaterialPageRoute(builder: (c) => const HomeScreen()));
      //});
    }
  }

  Future<void> readDataAndSetDataLocally(User currentUser) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection("users")
          .doc(currentUser.uid)
          .get();

      if (snapshot.exists) {
        await sharedPreferences!.setString('uid', currentUser.uid);
        await sharedPreferences!.setString('email', snapshot.get('userEmail'));
        await sharedPreferences!.setString('name', snapshot.get('userName'));
        await sharedPreferences!.setString('photoUrl', snapshot.get('userPhotoUrl'));

        Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(builder: (context) => const UsersHomeScreen()));
      } else {
        // Check if the user is registered as a seller
        final sellerSnapshot = await FirebaseFirestore.instance
            .collection("users")
            .doc(currentUser.uid)
            .get();
        print("users snapshot exists: ${sellerSnapshot.exists}");
        if (sellerSnapshot.exists) {
          print("User identified as a seller");
          Navigator.pop(context);
          showDialog(
            context: context,
            builder: (context) {
              return const ErrorDialog(
                message: " users account found! Please login using the seller portal.",
              );
            },
          );
        }

        else {
          Navigator.pop(context);
          showDialog(
            context: context,
            builder: (context) {
              return const ErrorDialog(message: "users does not exist! Register");
            },
          );

          firebaseAuth.signOut();
          Navigator.push(context, MaterialPageRoute(builder: (context) => const AuthScreen()));
        }
      }
    } catch (error) {
      print("Error fetching data from Firestore: $error");
      Navigator.pop(context);
      showDialog(
        context: context,
        builder: (context) {
          return const ErrorDialog(message: "An error occurred while fetching data! Please try again.");
        },
      );
      firebaseAuth.signOut();
      Navigator.push(context, MaterialPageRoute(builder: (context) => const AuthScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Image.asset(
                "images/login.png",
                height: 270,
              ),
            ),
          ),
          Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  UsersCustomTextFormField(
                    controller: _emailController,
                    iconData: Icons.email,
                    hintText: 'Enter your email',
                    isObscured: false,
                    isEnabled: true,
                    validationText: '',

                  ),
                  UsersCustomTextFormField(
                    controller: _passwordController,
                    iconData: Icons.lock,
                    hintText: 'Enter your password',
                    isObscured: true,
                    isEnabled: true,
                    validationText: '',

                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      print("Sigin clicked");
                      forValidation();
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 50, vertical: 10),
                      backgroundColor: Colors.purple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: const Text(
                      "Login",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
