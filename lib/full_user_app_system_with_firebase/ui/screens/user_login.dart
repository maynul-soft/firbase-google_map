import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:learn_firebase_database/full_user_app_system_with_firebase/data/model/user_detail_model.dart';
import 'package:learn_firebase_database/full_user_app_system_with_firebase/ui/controller/auth_controller.dart';
import 'package:learn_firebase_database/full_user_app_system_with_firebase/ui/screens/home_screen.dart';
import 'package:learn_firebase_database/full_user_app_system_with_firebase/ui/screens/register_screen.dart';
import 'package:learn_firebase_database/full_user_app_system_with_firebase/utils/all_key.dart';

import '../widgets/pop_up_message.dart';

class UserLogin extends StatefulWidget {
  const UserLogin({super.key});

  @override
  State<UserLogin> createState() => _UserLoginState();
}

class _UserLoginState extends State<UserLogin> {
  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();

  FirebaseFirestore db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Log In')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              TextFormField(
                controller: _emailTEController,
                  decoration: InputDecoration(hintText: 'Email')),
              SizedBox(height: 20),
              TextFormField(
                  controller: _passwordTEController,
                  decoration: InputDecoration(hintText: 'Password')),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  userLogIn();
                },
                child: Text('Login'),
              ),
              SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => RegisterScreen(),
                    ),
                  );
                },
                child: Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> userLogIn() async {
    final userManagement = db.collection(AllKey.collection);

    String email = _emailTEController.text;
    String password = _passwordTEController.text;

    final hasUser = await db.collection(AllKey.collection).doc(email).get();

    debugPrint('User email: $email');
    debugPrint('User data: $hasUser');


    if (!hasUser.exists) {
      if(!mounted)return;
      showPopUp(context, message: 'No user Found');
    } else {
      final userData = hasUser.data();
      final profileInformation = userData![AllKey.userDetailsKey];

      UserDetailsModel userDetailsModel = UserDetailsModel.fromFirebase(
        profileInformation,
      );

      await AuthController.setUserInformation(profileInformation);


      if (email == userDetailsModel.email &&
          password == userDetailsModel.password) {
        if (!mounted) return;
        debugPrint('ashse');
        Navigator.push(
          context,
          MaterialPageRoute(builder: (BuildContext context) => HomeScreen()),
        );
      } else {
        if (!mounted) return;
        showPopUp(context, message: 'Wrong user credentials');
      }
    }
  }

  @override
  void dispose() {
    _emailTEController.dispose();
    _passwordTEController.dispose();
    super.dispose();
  }
}
