import 'package:flutter/material.dart';

showPopUp(context, {required String message}){
 return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(message))
  );
}