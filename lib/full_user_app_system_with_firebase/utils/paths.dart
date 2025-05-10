import 'package:cloud_firestore/cloud_firestore.dart';
import 'all_key.dart';

class Paths {

  static FirebaseFirestore _db = FirebaseFirestore.instance;
  static CollectionReference<Map<String, dynamic>> addEventPath (email){

     return _db
             .collection(AllKey.collection)
             .doc(email)
             .collection(AllKey.serviceCollection);
  }
  static Stream<QuerySnapshot<Map<String, dynamic>>> getEventPath (email){

     return _db
             .collection(AllKey.collection)
             .doc(email)
             .collection(AllKey.serviceCollection).snapshots();
  }
  static Future<void> deleteEventPath ({required String email, required String id}){

     return _db
             .collection(AllKey.collection)
             .doc(email)
             .collection(AllKey.serviceCollection).doc(id).delete();
  }
}