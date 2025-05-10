import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:learn_firebase_database/full_user_app_system_with_firebase/data/model/event_model.dart';
import 'package:learn_firebase_database/full_user_app_system_with_firebase/ui/controller/auth_controller.dart';
import 'package:learn_firebase_database/full_user_app_system_with_firebase/ui/screens/add_event.dart';
import 'package:learn_firebase_database/full_user_app_system_with_firebase/ui/screens/user_login.dart';
import 'package:learn_firebase_database/full_user_app_system_with_firebase/utils/paths.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

List<EventModel> events = [];

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              AuthController.clearAllInformation();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => UserLogin(),
                ),
                (predicate) => false,
              );
            },
            icon: Icon(Icons.logout_sharp),
          ),
        ],
        title: Text(AuthController.name!),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (BuildContext context) => AddEvent()),
          );
        },
        child: Icon(Icons.add),
      ),
      body: StreamBuilder(
        stream: Paths.getEventPath(AuthController.email),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }
          if (snapshot.hasData == false) {
            return SizedBox();
          }

          events.clear();

          for (QueryDocumentSnapshot data in snapshot.data!.docs) {
            EventModel eventModel = EventModel.fromFirebase(data, id: data.id);
            events.add(eventModel);
          }

          return SingleChildScrollView(
            child: ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: events.length,
              itemBuilder: (BuildContext context, int index) {
                var getEvent = events[index];
                return Card(
                  child: ListTile(
                    title: Text(
                      getEvent.title,
                      overflow: TextOverflow.visible,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 8),
                        Text(getEvent.details, overflow: TextOverflow.visible),

                        SizedBox(height: 12),

                        Container(
                          decoration: BoxDecoration(
                            color: Color(0xffa0bcdd),
                            borderRadius: BorderRadius.circular(10)
                          ),
                          padding: EdgeInsets.all(5),
                          child: Text(getEvent.dateTime,style: TextStyle(fontSize: 8),),
                        ),
                      ],
                    ),
                    trailing: IconButton(
                      onPressed: () {
                        deleteEvent(AuthController.email,getEvent.id);
                      },
                      icon: Icon(Icons.delete, color: Colors.red),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Future<void>deleteEvent(email,id)async{
    await Paths.deleteEventPath(email: email, id: id);
  }
}
