import 'package:flutter/material.dart';
import 'package:learn_firebase_database/full_user_app_system_with_firebase/ui/controller/auth_controller.dart';
import 'package:learn_firebase_database/full_user_app_system_with_firebase/ui/screens/home_screen.dart';
import 'package:learn_firebase_database/full_user_app_system_with_firebase/ui/screens/user_login.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {





  Future<void> goToNextScreen() async {

    bool isLoggedIn = await AuthController.isLoggedIn();
    await AuthController.getUserInformation();

    await Future.delayed(Duration(seconds: 3));
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder:
            (BuildContext context) => isLoggedIn ? HomeScreen() : UserLogin(),
      ),
      (route) => false,
    );
  }

  @override
  void initState() {
    super.initState();
    goToNextScreen();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.fireplace_sharp, size: 40, color: Color(0xffff7933)),
            Text(
              'Firebase',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            Text(
              'Firestore',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Color(0xffff7933),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
