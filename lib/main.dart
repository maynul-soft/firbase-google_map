import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:learn_firebase_database/live_score_model.dart';
import 'firebase_firestore_practice_without_streambuilder.dart';
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
    return MaterialApp(debugShowCheckedModeBanner: false, home: FirebaseFireStorePracticeWithoutStreambuilder());
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  List<LiveScoreModel> liveScoreList = [];


  final FirebaseFirestore db = FirebaseFirestore.instance;

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Learn Firebase')),
      body: StreamBuilder(
        stream: db.collection('football').snapshots(),
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(child: CircularProgressIndicator(),);
          }
          if(snapshot.hasError){
            return Center(child: Text(snapshot.error.toString()),);
          }
          if(snapshot.hasData == false){
            return SizedBox();
          }

          liveScoreList.clear();

          for(QueryDocumentSnapshot s in snapshot.data!.docs){
            LiveScoreModel liveScoreModel = LiveScoreModel.fromJson(id: s.id, json: s.data() as Map<String, dynamic>);
          liveScoreList.add(liveScoreModel);
          }
          return ListView.builder(
            itemCount: liveScoreList.length,
            itemBuilder: ((BuildContext context, int index) {
              LiveScoreModel liveScore = liveScoreList[index];
              return Card(
                child: ListTile(
                  title: Text('${liveScore.metchTitle}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Team 1: ${liveScore.team1}'),
                      Text('Team 2 ${liveScore.team2}'),
                      liveScore.winnerTeam.isEmpty || liveScore.isRunning?
                      Row(
                        children: [
                         Text('Live'),
                          SizedBox(width: 4,),
                          CircleAvatar(radius: 5,backgroundColor: Colors.red,)
                        ],
                      ):
                      Text('Winner: ${liveScore.winnerTeam}'),
                    ],
                  ),
                  trailing: Text(
                    '${liveScore.team1Score}:${liveScore.team2Score}',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
              );
            }),
          );
        }
      ),
    );
  }
}
