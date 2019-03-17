import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import 'formatters.dart';
import 'model/bid.dart';
import 'model/hand.dart';
import 'model/match.dart';
import 'model/round.dart';
import 'new_hand_screen.dart';

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
      appBar: AppBar(
        title: Text("${match.teamA.name} vs ${match.teamB.name}"),
        actions: <Widget>[
          // action button
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      NewHandScreen(this.matchReference, this.roundReference),
                )),
          ),
        ],
      ),
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
    return ListView.separated(
      separatorBuilder: (context, index) => Divider(
            color: Colors.grey,
            height: 0.0,
          ),
      itemCount: snapshot.length,
      itemBuilder: (context, index) => _buildListItem(context, snapshot[index]),
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot handSnapshot) {
    final hand = Hand.fromMap(handSnapshot.data);

    bool isLast = hand.handNumber == round.numHands - 1;

    TextStyle mainStyle = Theme.of(context).textTheme.subhead;
    int winsFlex = 1;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: winsFlex,
            child: _buildTeamDetails(
                hand.biddingTeam == 0,
                hand.tricksWon,
                hand.pointsTeamA,
                hand.cumPointsTeamA,
                hand.actualBid,
                isLast,
                false),
          ),
          Expanded(
            flex: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Text(
                ":",
                textAlign: TextAlign.center,
                style: mainStyle,
              ),
            ),
          ),
          Expanded(
            flex: winsFlex,
            child: _buildTeamDetails(
                hand.biddingTeam == 1,
                hand.tricksWon,
                hand.pointsTeamB,
                hand.cumPointsTeamB,
                hand.actualBid,
                isLast,
                true),
          ),
        ],
      ),
    );
  }

  Widget _buildTeamDetails(bool biddingTeam, int tricksWonByBiddingTeam,
      int points, int cumPoints, Bid bid, bool isLast, bool reversed) {
    TextStyle mainStyle = Theme.of(context).textTheme.subhead;
    int tricksWonByTeam =
        biddingTeam ? tricksWonByBiddingTeam : 10 - tricksWonByBiddingTeam;

    var children = <Widget>[
      Expanded(
        flex: 1,
        child: Text(
          biddingTeam ? bid.getSymbol() : "",
          textAlign: reversed ? TextAlign.right : TextAlign.left,
          style: mainStyle,
        ),
      ),
      Expanded(
        flex: 3,
        child: Column(
          children: <Widget>[
            Text(
              "won $tricksWonByTeam",
              style: mainStyle,
              textScaleFactor: 0.85,
            ),
            Text(
              Formatters.formatPoints(points),
              style: mainStyle.apply(
                color: Formatters.getColor(points, biddingTeam),
              ),
              textScaleFactor: 0.85,
            ),
          ],
        ),
      ),
      Expanded(
        flex: 1,
        child: Text(
          cumPoints.toString(),
          textAlign: reversed ? TextAlign.left : TextAlign.right,
          style: mainStyle.apply(
              decoration:
                  isLast ? TextDecoration.none : TextDecoration.lineThrough),
        ),
      ),
    ];

    return Row(
        children: reversed ? children.reversed.toList() : children.toList());
  }
}

class Snapshots {
  final DocumentSnapshot matchSnapshot;
  final DocumentSnapshot roundSnapshot;

  Snapshots(this.matchSnapshot, this.roundSnapshot);
}
