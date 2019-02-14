import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'model/hand.dart';
import 'model/match.dart';
import 'model/round.dart';

class RoundScreen extends StatefulWidget {
  final Match match;
  final Round round;

  RoundScreen(this.match, this.round);

  @override
  _RoundScreenState createState() {
    return _RoundScreenState(this.match, this.round);
  }
}

class _RoundScreenState extends State<RoundScreen> {
  final Match match;
  final Round round;

  _RoundScreenState(this.match, this.round);

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
          .document(round.reference.documentID)
          .collection("hands")
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
    final hand = Hand.fromSnapshot(data);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: ListTile(
          title: Text(
              "${hand.pointsTeamA} vs ${hand.pointsTeamB} with bid ${hand.bid.getSymbol()}"),
          onTap: () => print(round),
        ),
      ),
    );
  }
}
