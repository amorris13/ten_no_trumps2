import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import 'formatters.dart';
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

        print("round screen new snapshot");

        Snapshots snapshots = snapshot.data;
        return RoundWidget.fromSnapshots(
            snapshots.matchSnapshot, snapshots.roundSnapshot);
      },
    );
  }
}

class RoundWidget extends StatelessWidget {
  final DocumentReference matchReference;
  final Match match;

  final DocumentReference roundReference;
  final Round round;

  RoundWidget(this.matchReference, this.match, this.roundReference, this.round);

  static fromSnapshots(
      DocumentSnapshot matchSnapshot, DocumentSnapshot roundSnapshot) {
    return RoundWidget(
        matchSnapshot.reference,
        Match.fromMap(matchSnapshot.data),
        roundSnapshot.reference,
        Round.fromMap(roundSnapshot.data));
  }

  @override
  Widget build(BuildContext context) {
    print("round widget building with round $round");

    var actions = <Widget>[];
    if (!round.finished) {
      actions.add(IconButton(
        icon: Icon(Icons.add),
        onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  NewHandScreen(this.matchReference, this.roundReference),
            )),
      ));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("${match.teamA.name} vs ${match.teamB.name}"),
        actions: actions,
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream:
          roundReference.collection("hands").orderBy("handNumber").snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();

        return _buildList(context, snapshot.data.documents);
      },
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return snapshot.isEmpty
        ? Center(child: Text("Click + to create a hand"))
        : ListView.separated(
            separatorBuilder: (context, index) => Divider(
                  color: Theme.of(context).dividerColor,
                  height: 0.0,
                ),
            itemCount: snapshot.length,
            itemBuilder: (context, index) =>
                _buildListItem(context, snapshot[index]),
          );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot handSnapshot) {
    final hand = Hand.fromMap(handSnapshot.data);

    bool isLast = hand.handNumber == round.numHands - 1;

    TextStyle mainStyle = Theme.of(context).textTheme.subhead;
    int winsFlex = 1;

    var rows = <Widget>[
      Row(
        children: <Widget>[
          Expanded(
            flex: winsFlex,
            child: _buildTeamDetailsSimple(context, hand, 0, isLast, false),
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
            child: _buildTeamDetailsSimple(context, hand, 1, isLast, true),
          ),
        ],
      ),
    ];

    if (round.finished && isLast) {
      String winningTeam = match.getTeam(round.winningTeam).name;
      rows.add(Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Text(
          "$winningTeam has won!",
          style: Theme.of(context).textTheme.title,
        ),
      ));
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        children: rows,
      ),
    );
  }

  Widget _buildTeamDetailsSimple(BuildContext context, Hand hand,
      int teamNumber, bool isLast, bool reversed) {
    bool biddingTeam = hand.biddingTeam == teamNumber;

    TextStyle mainStyle = Theme.of(context).textTheme.subhead;
    int tricksWonByTeam = biddingTeam ? hand.tricksWon : 10 - hand.tricksWon;

    var children = <Widget>[
      Expanded(
        flex: 1,
        child: Text(
          biddingTeam ? hand.actualBid.getSymbol() : "",
          textAlign: reversed ? TextAlign.right : TextAlign.left,
          style: mainStyle,
        ),
      ),
      Expanded(
        flex: 2,
        child: Column(
          children: <Widget>[
            Text(
              "won $tricksWonByTeam",
              style: mainStyle,
              textScaleFactor: 0.85,
            ),
            Text(
              Formatters.formatPoints(hand.getPoints(teamNumber)),
              style: mainStyle.apply(
                color: Formatters.getColor(
                    hand.getPoints(teamNumber), biddingTeam),
              ),
              textScaleFactor: 0.85,
            ),
          ],
        ),
      ),
      Expanded(
        flex: 1,
        child: Text(
          hand.getCumPoints(teamNumber).toString(),
          textAlign: reversed ? TextAlign.left : TextAlign.right,
          style: mainStyle.apply(
              decoration:
                  isLast ? TextDecoration.none : TextDecoration.lineThrough,
              color: isLast && round.finished
                  ? teamNumber == round.winningTeam
                      ? Formatters.winningColor
                      : Formatters.losingColor
                  : null,
              fontWeightDelta: isLast && round.finished ? 2 : 0),
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
