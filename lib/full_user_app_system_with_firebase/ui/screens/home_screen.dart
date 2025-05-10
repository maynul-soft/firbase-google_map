import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:learn_firebase_database/full_user_app_system_with_firebase/ui/controller/auth_controller.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  void initState() {
    super.initState();
    AuthController.getUserInformation();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AuthController.name!),
      ),
      floatingActionButton: FloatingActionButton(onPressed: (){},child: Icon(Icons.add),),
      body: SingleChildScrollView(
        child: ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: 20 ,
          itemBuilder: (BuildContext context, int index) { 
            return Card(
              child: ListTile(
                title: Text("Demo Title"),
                subtitle: Text('Demo Sub-title'),
                trailing: IconButton(onPressed: (){}, icon: Icon(Icons.delete,color: Colors.red,)),
              ),
            );
          },),
      ),
    );
  }

}
