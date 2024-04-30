import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as fStorage;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:users_noflie_foodpanda_clone/authentication/user_homescreen.dart';
import 'package:users_noflie_foodpanda_clone/widgets/custom_textfield.dart';

import '../global_variable/global.dart';
import '../widgets/error_dialog.dart';
import '../widgets/loading_dialog.dart';


class UsersRegistration extends StatefulWidget {
  const UsersRegistration({super.key});

  @override
  State<UsersRegistration> createState() => _UsersRegistrationState();
}

class _UsersRegistrationState extends State<UsersRegistration> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  XFile? imageXFile;
  final ImagePicker _picker = ImagePicker();


  String userPhotoUrl = "";

  Future<void> _getImage() async {
    imageXFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      imageXFile;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _nameController.clear();
    _emailController.clear();
    _passwordController.clear();
    _confirmPassword.clear();
   // _phoneController.clear();
  }


  Future<void> formValidation() async {
    if (imageXFile == null) {
      showDialog(
          context: context,
          builder: (c) {
            return const ErrorDialog(message: 'Image is required');
          });
    } else if (_nameController.text.isEmpty) {
      showDialog(
          context: context,
          builder: (c) {
            return const ErrorDialog(message: "Name is required");
          });
    } else if (!isValidEmail(_emailController.text)) {
      showDialog(
          context: context,
          builder: (c) {
            return const ErrorDialog(message: "A valid email is required");
          });
    } else if (_passwordController.text.isEmpty) {
      showDialog(
          context: context,
          builder: (c) {
            return const ErrorDialog(message: "Password is required");
          });
    } else if (_confirmPassword.text.isEmpty ||
        _confirmPassword.text != _passwordController.text) {
      showDialog(
          context: context,
          builder: (c) {
            return const ErrorDialog(
                message:
                "Confirm password is not the same and cannot be empty");
          });
    } else {
      showDialog(
          context: context,
          builder: (c) {
            return const LoadingDialog(message: "Registering Account");
          });
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      fStorage.Reference reference = fStorage.FirebaseStorage.instance
          .ref()
          .child("users")
          .child(fileName);
      fStorage.UploadTask uploadTask =
      reference.putFile(File(imageXFile!.path));
      fStorage.TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
      await taskSnapshot.ref.getDownloadURL().then((url) {
        userPhotoUrl = url;

        // Dismiss loading dialog before authentication
        Navigator.pop(context); // Close loading dialog

        // Save image to firestore.
        authenticateRidersAndSignUp();
      });
    }
  }

  void authenticateRidersAndSignUp() async {
    User? currentUser;
    //final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    showDialog(
      context: context,
      builder: (c) {
        return const LoadingDialog(message: "Registering Account");
      },
    );
    try {
      firebaseAuth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      currentUser = firebaseAuth.currentUser;
      // Dismiss loading dialog
      Navigator.pop(context);

      if (currentUser != null) {
        await saveDataToFirestore(currentUser).then((value) {
          Navigator.pop(context);
          Navigator.push(context, MaterialPageRoute(builder: (c) => const UsersHomeScreen()));
        });
      }
    } catch (error) {
      // Dismiss loading dialog
      Navigator.pop(context);

      // Show error dialog
      showDialog(
        context: context,
        builder: (c) {
          return ErrorDialog(message: error.toString());
        },
      );
    }
  }

  Future<void> saveDataToFirestore(User currentUser) async {
    try {
      // Example usage of saving to Firestore
      await FirebaseFirestore.instance
          .collection("users")
          .doc(currentUser.uid)
          .set({
        // Add data you want to save
        'userUID': currentUser.uid,
        'userEmail': currentUser.email,
        'userName': _nameController.text.trim(),
        'userPhotoUrl': userPhotoUrl,
        'status': "approved",
        'earnings': 0.0,
        // Add more fields as needed
      });

      //Save data locally
      sharedPreferences = await SharedPreferences.getInstance();
      await sharedPreferences!.setString('uid', currentUser.uid);
      await sharedPreferences!.setString('email', currentUser.email.toString());
      await sharedPreferences!.setString('name', _nameController.text.trim());
      await sharedPreferences!.setString('photoUrl', userPhotoUrl);

      print("Data saved to Firestore successfully.");
    } catch (error) {
      // Print out any errors that occur during Firestore write operation
      print("Error saving data to Firestore: $error");
    }
  }

  // Function to check if the email is valid
  bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

// Function to check if the phone number is valid
  bool isValidPhoneNumber(String phoneNumber) {
    return phoneNumber.isNotEmpty &&
        phoneNumber.length == 9 &&
        int.tryParse(phoneNumber) != null;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        //mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          const SizedBox(
            height: 8,
          ),
          InkWell(
            onTap: () {
              _getImage();
            },
            child: CircleAvatar(
              radius: MediaQuery.of(context).size.width * 0.16,
              backgroundColor: Colors.white38,
              backgroundImage: imageXFile == null
                  ? null
                  : FileImage(
                File(imageXFile!.path),
              ),
              child: imageXFile == null
                  ? Icon(
                Icons.add_photo_alternate,
                size: MediaQuery.of(context).size.width * 0.15,
                color: Colors.grey,
              )
                  : null,
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Form(
            key: _formKey,
            child: Column(
              children: [
                UsersCustomTextFormField(controller: _nameController, iconData: Icons.person, isEnabled: true, isObscured:false, hintText: "Your Username", validationText: "Some validation to be apply"),
                UsersCustomTextFormField(controller: _emailController, iconData: Icons.email, isEnabled: true, isObscured:false, hintText: "Enter your email", validationText: "Some validation to be apply"),
                UsersCustomTextFormField(controller: _passwordController, iconData: Icons.lock, isEnabled: true, isObscured:true, hintText: "Select password", validationText: "Some validation to be apply"),
                UsersCustomTextFormField(controller: _confirmPassword, iconData: Icons.lock, isEnabled: true, isObscured:true, hintText: "Confirm password", validationText: "Some validation to be apply"),
                //UsersCustomTextFormField(controller: _phoneController, iconData: Icons.phone, isEnabled: true, isObscured:false, hintText: "Enter your phone number", validationText: "Some validation to be apply"),
                //UsersCustomTextFormField(controller: _locationController, iconData: Icons.my_location, isEnabled: false, isObscured:false, hintText: "Accept Location", validationText: "Some validation to be apply"),

                const SizedBox(
                  height: 5,
                ),
                /*
                Container(
                  width: 400,
                  height: 40,
                  alignment: Alignment.center,
                  child: ElevatedButton.icon(
                    label: const Text(
                      "My Current Location",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: () {
                      print("Clicked for location");
                      //getCurretLocation();
                    },
                    icon: const Icon(
                      Icons.location_on,
                      color: Colors.white,
                    ),
                  ),
                ),*/
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                formValidation();
              });
              print("Sign up clicked");
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
              backgroundColor: Colors.purple,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            child: const Text(
              "Sign Up",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
