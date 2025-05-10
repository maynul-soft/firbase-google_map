import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:learn_firebase_database/full_user_app_system_with_firebase/utils/all_key.dart';
import '../widgets/pop_up_message.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameTEController = TextEditingController();
  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _mobileTEController = TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();

  FirebaseFirestore db = FirebaseFirestore.instance;

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Register')),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            TextFormField(
              controller: _nameTEController,
              decoration: InputDecoration(hintText: 'Name'),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _emailTEController,
              decoration: InputDecoration(hintText: 'Email'),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _mobileTEController,
              decoration: InputDecoration(hintText: 'mobile no'),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _passwordTEController,
              decoration: InputDecoration(hintText: 'Password'),
            ),
            ElevatedButton(
              onPressed: () {
                registerUser();
              },
              child: Visibility(
                visible: isLoading == false,
                replacement: Center(child: CircularProgressIndicator()),
                child: Text('Submit'),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> registerUser() async {
    isLoading = true;
    setState(() {});
    final userManagement = db.collection(AllKey.collection);

    String email = _emailTEController.text;

    Map<String, dynamic> userInformation = {
      AllKey.name: _nameTEController.text,
      AllKey.email: _emailTEController.text,
      AllKey.mobileNumber: _mobileTEController.text,
      AllKey.password: _passwordTEController.text,
    };

    final isMailAlreadyRegistered =
        await db.collection(AllKey.collection).doc(email).get();
    final createAllFieldOnDatabaseForNewUser = userManagement
        .doc(email)
        .collection(AllKey.serviceCollection)
        .doc(AllKey.newDocsInUserPanel);

    if (isMailAlreadyRegistered.exists) {
      if (!mounted) return;
      showPopUp(
        context,
        message: 'This Mail is already registered try with different mail',
      );
    } else {
      try {
        await userManagement.doc(email).set({AllKey.userDetailsKey:userInformation});
        createAllFieldOnDatabaseForNewUser.set({});
        clearAllTextField();
        if (!mounted) return;
        showPopUp(context, message: 'Registration Successfully');
      } catch (e) {
        if (!mounted) return;
        showPopUp(context, message: e.toString());
      }
    }
    isLoading = false;
    setState(() {});
  }

  clearAllTextField(){
    _nameTEController.clear();
    _emailTEController.clear();
    _mobileTEController.clear();
    _passwordTEController.clear();
  }

  @override
  void dispose() {
    _nameTEController.dispose();
    _emailTEController.dispose();
    _passwordTEController.dispose();
    _mobileTEController.dispose();
    super.dispose();
  }
}
