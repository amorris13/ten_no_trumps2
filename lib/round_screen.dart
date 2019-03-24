import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tuple/tuple.dart';

import 'common_widgets.dart';
import 'formatters.dart';
import 'model/hand.dart';
import 'model/match.dart';
import 'model/round.dart';
import 'model/scoring_prefs.dart';
import 'model/user.dart';
import 'new_hand_screen.dart';
import 'scoring_prefs_dialog.dart';

class RoundScreen extends StatelessWidget {
  final DocumentReference matchReference;
  final DocumentReference roundReference;
  final DocumentReference userReference;

  RoundScreen(this.userReference, this.matchReference, this.roundReference);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<
        Tuple3<DocumentSnapshot, DocumentSnapshot, DocumentSnapshot>>(
      stream: Observable.combineLatest3(
          userReference.snapshots(),
          matchReference.snapshots(),
          roundReference.snapshots(),
          (userSnapshot, matchSnapshot, roundSnapshot) =>
              Tuple3(userSnapshot, matchSnapshot, roundSnapshot)),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();

        return RoundWidget.fromSnapshots(
            snapshot.data.item1, snapshot.data.item2, snapshot.data.item3);
      },
    );
  }
}

class RoundWidget extends StatelessWidget {
  final DocumentReference userReference;
  final User user;

  final DocumentReference matchReference;
  final Match match;

  final DocumentReference roundReference;
  final Round round;

  RoundWidget(this.userReference, this.user, this.matchReference, this.match,
      this.roundReference, this.round);

  static fromSnapshots(DocumentSnapshot userSnapshot,
      DocumentSnapshot matchSnapshot, DocumentSnapshot roundSnapshot) {
    return RoundWidget(
        userSnapshot.reference,
        User.fromMap(userSnapshot.data),
        matchSnapshot.reference,
        Match.fromMap(matchSnapshot.data),
        roundSnapshot.reference,
        Round.fromMap(roundSnapshot.data));
  }

  @override
  Widget build(BuildContext context) {
    var actions = <Widget>[];

    if (!round.finished) {
      actions.add(IconButton(
        icon: Icon(Icons.assessment),
        onPressed: () => showDialog<ScoringPrefs>(
              context: context,
              builder: (dialogContext) =>
                  ScoringPrefsDialog(round.scoringPrefsNonNull),
            ).then((scoringPrefs) {
              RoundBuilder roundBuilder = round.toBuilder();
              roundBuilder.scoringPrefs = scoringPrefs.toBuilder();
              Round updatedRound = roundBuilder.build();
              roundReference.setData(updatedRound.toMap(), merge: true);

              // And update the user preferences
              UserBuilder userBuilder = user.toBuilder();
              userBuilder.scoringPrefs = scoringPrefs.toBuilder();
              User updatedUser = userBuilder.build();
              userReference.setData(updatedUser.toMap(), merge: true);
            }),
      ));

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
        title: Text("Round"),
        actions: actions,
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Column(
      children: <Widget>[
        _buildHeader(context, match),
        Divider(height: 0.0),
        Flexible(
          child: StreamBuilder<QuerySnapshot>(
            stream: roundReference
                .collection("hands")
                .orderBy("handNumber")
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return LinearProgressIndicator();

              return _buildList(context, snapshot.data.documents);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context, Match match) {
    TextStyle mainStyle = Theme.of(context).textTheme.title;
    return Padding(
      padding: EdgeInsets.only(top: 12.0, bottom: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: Text(
              match.teamA.name,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: mainStyle,
            ),
          ),
          Expanded(
            child: Text(
              match.teamB.name,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: mainStyle,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return snapshot.isEmpty
        ? Padding(
            padding: EdgeInsets.only(top: 16.0),
            child: Center(child: Text("Click + to create a hand")))
        : ListView.separated(
            separatorBuilder: (context, index) => Divider(height: 0.0),
            itemCount: snapshot.length,
            itemBuilder: (context, index) =>
                _buildListItem(context, snapshot[index]),
          );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot handSnapshot) {
    DocumentReference handReference = handSnapshot.reference;
    Hand hand = Hand.fromMap(handSnapshot.data);

    bool isLast = hand.handNumber == round.numHands - 1;

    TextStyle mainStyle = Theme.of(context).textTheme.subhead;
    int winsFlex = 1;

    Widget handDetails = Row(
      children: <Widget>[
        Expanded(
          flex: winsFlex,
          child: _buildTeamDetails(context, hand, 0, isLast, false),
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
          child: _buildTeamDetails(context, hand, 1, isLast, true),
        ),
      ],
    );

    if (isLast && !round.finished) {
      handDetails = Dismissible(
          background: new LeaveBehindWidget(alignment: Alignment.centerLeft),
          secondaryBackground:
              new LeaveBehindWidget(alignment: Alignment.centerRight),
          key: Key(hand.toString()),
          onDismissed: (direction) {
            handReference.delete();
            RoundBuilder roundBuilder = round.toBuilder();
            roundBuilder.teamAScore -= hand.pointsTeamA;
            roundBuilder.teamBScore -= hand.pointsTeamB;
            roundBuilder.numHands--;

            roundReference.setData(roundBuilder.build().toMap(), merge: true);

            Scaffold.of(context).hideCurrentSnackBar();
            Scaffold.of(context).showSnackBar(
              SnackBar(
                content: Text("Hand Deleted"),
                action: SnackBarAction(
                  label: 'Undo',
                  onPressed: () {
                    roundReference.get().then((round) {
                      RoundBuilder roundBuilder =
                          Round.fromMap(round.data).toBuilder();

                      roundBuilder.teamAScore += hand.pointsTeamA;
                      roundBuilder.teamBScore += hand.pointsTeamB;
                      roundBuilder.numHands++;

                      roundReference.setData(roundBuilder.build().toMap(),
                          merge: true);
                    });

                    Firestore.instance
                        .document(handReference.path)
                        .setData(handSnapshot.data);
                  },
                ),
              ),
            );
          },
          child: handDetails);
    }

    var rows = <Widget>[handDetails];

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
        mainAxisSize: MainAxisSize.min,
        children: rows,
      ),
    );
  }

  Widget _buildTeamDetails(BuildContext context, Hand hand, int teamNumber,
      bool isLast, bool reversed) {
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
          mainAxisSize: MainAxisSize.min,
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
