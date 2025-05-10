import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:learn_firebase_database/full_user_app_system_with_firebase/utils/all_key.dart';

class EventModel {
  String id;
  String title;
  String details;
  String dateTime;

  EventModel({
    required this.title,
    required this.details,
    required this.dateTime,
    required this.id,
  });

  factory EventModel.fromFirebase(
    QueryDocumentSnapshot firebaseData, {
    required String id,
  }) {
    return EventModel(
      id: id,
      title: firebaseData[AllKey.eventTitle],
      details: firebaseData[AllKey.eventDetails],
      dateTime: firebaseData[AllKey.eventTime],
    );
  }
}
