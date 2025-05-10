import 'dart:convert';

import 'package:learn_firebase_database/full_user_app_system_with_firebase/data/model/user_detail_model.dart';
import 'package:learn_firebase_database/full_user_app_system_with_firebase/utils/all_key.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController{
  static  String? email;
  static  String? name;
  static UserDetailsModel? userInfo;


  static final String saveDataKey = 'userInfoMap';

 static Future<void> setUserInformation(Map<String,dynamic> userInformation )async{
   SharedPreferences preferences = await SharedPreferences.getInstance();
   Logger().e(userInformation);
   String userInformationText = jsonEncode(userInformation);
   preferences.setString(saveDataKey, userInformationText);

   email = userInformation[AllKey.email];
   name = userInformation[AllKey.name];
 }

  static Future<void> getUserInformation()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();

    String? userInformationString = preferences.getString(saveDataKey);

    if(userInformationString != null){
      Map<String,dynamic> userInformation = jsonDecode(userInformationString);
      UserDetailsModel userDetailsModel = UserDetailsModel.fromFirebase(userInformation);
      email = userDetailsModel.email;
      name = userDetailsModel.name;
      userInfo = userDetailsModel;

    }
  }

  Future<void>clearAllInformation()async{
   SharedPreferences preferences = await SharedPreferences.getInstance();
   preferences.clear();
   email = null;
   name = null;

  }
}