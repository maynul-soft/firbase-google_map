import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:learn_firebase_database/live_score_model.dart';

class FirebaseFireStorePracticeWithoutStreambuilder extends StatefulWidget {
  const FirebaseFireStorePracticeWithoutStreambuilder({super.key});

  @override
  State<FirebaseFireStorePracticeWithoutStreambuilder> createState() =>
      _FirebaseFireStorePracticeWithoutStreambuilderState();
}

class _FirebaseFireStorePracticeWithoutStreambuilderState
    extends State<FirebaseFireStorePracticeWithoutStreambuilder> {
  FirebaseFirestore db = FirebaseFirestore.instance;

  List<LiveScoreModel> matchInfo = [];

  @override
  void initState() {
    super.initState();
    getMatchInfo();
  }

  Future<void> getMatchInfo() async {
    QuerySnapshot snapshot = await db.collection("football").get();
    for (QueryDocumentSnapshot snapshot in snapshot.docs) {
      LiveScoreModel liveScoreModel = LiveScoreModel.fromJson(
        id: snapshot.id,
        json: snapshot.data() as Map<String, dynamic>,
      );
      matchInfo.add(liveScoreModel);
    }
    setState(() {});
  }

  Future<void>updateSpecificField()async{
    final updateField = db.collection('football');

    try{
      await updateField.doc('gervsned').update({
        'team_1_score': 4,
        'team_2_Score': 3,
      });
      matchInfo.clear();
      await getMatchInfo();
    }catch(e){
      debugPrint(e.toString());
    }
  }



  Future<void> addData() async {
    final addMatch = db.collection('football');
    Map<String, dynamic> newMatch = {
      'isRunning': false,
      'metch_title': 'GER vs NED',
      'team1': 'Germoney',
      'team2': 'Nederland',
      'team_1_score': 2,
      'team_2_Score': 1,
      'winnerTeam': 'Germoney',
    };

    matchInfo.clear();

    try {
      await addMatch.doc('gervsned').set(newMatch);
      await getMatchInfo();
    } catch (e) {
      debugPrint(e.toString());
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Learn Firestore")),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  addData();
                },
                child: Text('Add Data'),
              ),
              ElevatedButton(
                onPressed: () {
                  updateSpecificField();
                },
                child: Text('Update Data'),
              ),
            ],
          ),
          ListView.builder(
            shrinkWrap: true,
            itemCount: matchInfo.length,
            itemBuilder: (BuildContext context, int index) {
              LiveScoreModel matchInformation = matchInfo[index];
              return Card(
                child: ListTile(
                  title: Text(matchInformation.metchTitle),
                  trailing: Text('${matchInformation.team1Score}:${matchInformation.team2Score}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Team1 : ${matchInformation.team1}'),
                      Text('Team2 : ${matchInformation.team2}'),
                      matchInformation.winnerTeam.isEmpty
                          ? Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text('Live'),
                              CircleAvatar(
                                radius: 5,
                                backgroundColor: Colors.red,
                              ),
                            ],
                          )
                          : Text('Winner Team: ${matchInformation.winnerTeam}'),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
