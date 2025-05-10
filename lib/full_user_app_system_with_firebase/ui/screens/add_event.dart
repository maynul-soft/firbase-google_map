import 'package:flutter/material.dart';
import 'package:learn_firebase_database/full_user_app_system_with_firebase/ui/controller/auth_controller.dart';
import 'package:learn_firebase_database/full_user_app_system_with_firebase/ui/widgets/pop_up_message.dart';
import 'package:learn_firebase_database/full_user_app_system_with_firebase/utils/all_key.dart';
import 'package:learn_firebase_database/full_user_app_system_with_firebase/utils/paths.dart';

class AddEvent extends StatefulWidget {
  const AddEvent({super.key});

  @override
  State<AddEvent> createState() => _AddEventState();
}

class _AddEventState extends State<AddEvent> {
  final TextEditingController _titleTEController = TextEditingController();
  final TextEditingController _detailsTEController = TextEditingController();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: _titleTEController,
              decoration: InputDecoration(hintText: 'title'),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _detailsTEController,
              decoration: InputDecoration(hintText: 'Details'),
              maxLines: 5,
            ),
            SizedBox(height: 20),
            ElevatedButton(onPressed: () {
              addEvent();
            }, child: Visibility(
                visible: isLoading == false,
                replacement: Center(child: CircularProgressIndicator(),),
                child: Text('Add')))
          ],
        ),
      ),
    );
  }

  Future<void> addEvent() async {
    isLoading = true;
    setState(() {});
    final addEnverPath = Paths.addEventPath(AuthController.email);

    DateTime now = DateTime.now();

    String dateTime = 'Date: ${now.day.toString().padLeft(2, '0')}-${now.month
        .toString().padLeft(2, '0')}-${now.year} Time: ${now.hour
        .toString()
        .padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

    Map<String, dynamic> event = {
    AllKey.eventTitle: _titleTEController.text,
    AllKey.eventDetails: _detailsTEController.text,
    AllKey.eventTime: dateTime,
    };
    try{
    await addEnverPath.doc(DateTime.now().toString()).set(event);
    clearAllTextField();
    }catch(e){
    if(!mounted)return;
    showPopUp(context, message: e.toString());
    }
    isLoading = false;
    setState(() {});
  }

  clearAllTextField() {
    _titleTEController.clear();
    _detailsTEController.clear();
  }

  @override
  void dispose() {
    _titleTEController.dispose();
    _detailsTEController.dispose();
    super.dispose();
  }
}
