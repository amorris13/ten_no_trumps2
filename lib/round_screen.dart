import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import 'model/hand.dart';
import 'model/match.dart';
import 'model/round.dart';

class RoundScreen extends StatelessWidget {
  final DocumentReference matchReference;
  final DocumentReference roundReference;

  RoundScreen(this.matchReference, this.roundReference);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Snapshots>(
      stream: Observable.combineLatest2(
          matchReference.snapshots(),
          roundReference.snapshots(),
          (matchSnapshot, roundSnapshot) =>
              Snapshots(matchSnapshot, roundSnapshot)),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();

        Snapshots snapshots = snapshot.data;
        return RoundWidget(snapshots.matchSnapshot, snapshots.roundSnapshot);
      },
    );
  }
}

class RoundWidget extends StatefulWidget {
  final DocumentSnapshot match;
  final DocumentSnapshot round;

  RoundWidget(this.match, this.round);

  @override
  _RoundWidgetState createState() {
    return _RoundWidgetState.fromSnapshots(match, round);
  }
}

class _RoundWidgetState extends State<RoundWidget> {
  final DocumentReference matchReference;
  final Match match;

  final DocumentReference roundReference;
  final Round round;

  _RoundWidgetState(
      this.matchReference, this.match, this.roundReference, this.round);

  _RoundWidgetState.fromSnapshots(
      DocumentSnapshot matchSnapshot, DocumentSnapshot roundSnapshot)
      : matchReference = matchSnapshot.reference,
        match = Match.fromMap(matchSnapshot.data),
        roundReference = roundSnapshot.reference,
        round = Round.fromMap(roundSnapshot.data);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("${match.teamA.name} vs ${match.teamB.name}")),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: roundReference.collection("hands").snapshots(),
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

  Widget _buildListItem(BuildContext context, DocumentSnapshot handSnapshot) {
    final hand = Hand.fromMap(handSnapshot.data);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: ListTile(
          title: Text(
              "${hand.pointsTeamA} vs ${hand.pointsTeamB} with bid ${hand.actualBid.getSymbol()}"),
          onTap: () => print(round),
        ),
      ),
    );
  }
}

class Snapshots {
  final DocumentSnapshot matchSnapshot;
  final DocumentSnapshot roundSnapshot;

  Snapshots(this.matchSnapshot, this.roundSnapshot);
}
