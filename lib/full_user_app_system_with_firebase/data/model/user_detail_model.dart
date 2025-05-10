import 'package:learn_firebase_database/full_user_app_system_with_firebase/utils/all_key.dart';

class UserDetailsModel{
  final String name;
  final String email;
  final String mobileNo;
  final String password;

  UserDetailsModel({required this.name, required this.email, required this.mobileNo, required this.password});

  factory UserDetailsModel.fromFirebase(Map<String, dynamic>firebaseResponse){
    return UserDetailsModel(
        name: firebaseResponse[AllKey.name],
        email: firebaseResponse[AllKey.email],
        mobileNo: firebaseResponse[AllKey.mobileNumber],
        password: firebaseResponse[AllKey.password]
    );
  }


}