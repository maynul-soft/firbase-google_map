import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:learn_firebase_database/live_score_model.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: HomeScreen());
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    getLiveScore();
  }

  List<LiveScoreModel> liveScoreList = [];
  bool isLoading = false;

  final FirebaseFirestore db = FirebaseFirestore.instance;

  Future<void> getLiveScore() async {
    isLoading = true;
    setState(() {});

    QuerySnapshot snapshot = await db.collection('football').get();
    for (QueryDocumentSnapshot s in snapshot.docs) {
      LiveScoreModel liveScoreModel = LiveScoreModel.fromJson(
        id: s.id,
        json: s.data() as Map<String, dynamic>,
      );

      liveScoreList.add(liveScoreModel);
      print(
        '${liveScoreList[0].id}'
        '${liveScoreList[0].team1}'
        '${'Length: ${liveScoreList.length}'}',
      );
    }
    isLoading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Learn Firebase')),
      body: Visibility(
        visible: isLoading == false,
        replacement: Center(child: CircularProgressIndicator()),
        child: ListView.builder(
          itemCount: liveScoreList.length,
          itemBuilder: ((BuildContext context, int index) {
            LiveScoreModel liveScore = liveScoreList[index];
            return Card(
              child: ListTile(
                title: Text('${liveScore.metchTitle}'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${liveScore.team1}'),
                    Text('${liveScore.team1}'),
                    liveScore.winnerTeam.isEmpty?
                    Row(
                      children: [
                       Text('Live'),
                        SizedBox(width: 4,),
                        CircleAvatar(radius: 5,backgroundColor: Colors.red,)
                      ],
                    ):
                    Text(liveScore.winnerTeam),
                  ],
                ),
                trailing: Text(
                  '${liveScore.team1Score}:${liveScore.team2Score}',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                leading: CircleAvatar(radius: 8, backgroundColor: Colors.blue),
              ),
            );
          }),
        ),
      ),
    );
  }
}
