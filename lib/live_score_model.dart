

class LiveScoreModel {
  final String id;
  final String metchTitle;
  final bool isRunning;
  final String team1;
  final String team2;
  final int team1Score;
  final int team2Score;
  final String winnerTeam;

  LiveScoreModel(
      {required this.id, required this.metchTitle, required this.isRunning, required this.team1, required this.team2, required this.team1Score, required this.team2Score, required this.winnerTeam});

  factory LiveScoreModel.fromJson(
      {required String? id, required Map<String, dynamic> json }){
    return LiveScoreModel(
        id: id??'',
        metchTitle: json['metch_title']??'',
        isRunning: json['isRunning']??'',
        team1: json['team1']??'',
        team2: json['team2']??'',
        team1Score: json['team_1_score']??0,
        team2Score: json['team_2_Score']??0,
        winnerTeam: json['winnerTeam']??'');
  }

}
