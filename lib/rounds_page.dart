import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'model/match.dart';
import 'model/round.dart';

class RoundsPage extends StatefulWidget {
  final Match match;

  RoundsPage(this.match);

  @override
  _RoundsPageState createState() {
    return _RoundsPageState(this.match);
  }
}

class _RoundsPageState extends State<RoundsPage> {
  final Match match;

  _RoundsPageState(this.match);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("${match.teamA.name} vs ${match.teamB.name}")),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
          .collection('matches')
          .document(match.reference.documentID)
          .collection("rounds")
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();

        return _buildList(context, snapshot.data.documents);
      },
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
      padding: const EdgeInsets.only(top: 20.0),
      children: snapshot.map((data) => _buildListItem(context, data)).toList(),
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    final round = Round.fromSnapshot(data);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: ListTile(
          title: Text("${round.teamAScore} vs ${round.teamBScore}"),
          onTap: () => print(round),
        ),
      ),
    );
  }
}