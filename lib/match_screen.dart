import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'common_widgets.dart';
import 'model/match.dart';
import 'model/round.dart';
import 'round_screen.dart';

class MatchScreen extends StatelessWidget {
  final DocumentReference matchReference;

  MatchScreen(this.matchReference);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: matchReference.snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();

        return _buildScreen(context, Match.fromMap(snapshot.data.data));
      },
    );
  }

  Widget _buildScreen(BuildContext context, Match match) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${match.teamA.name} vs ${match.teamB.name}"),
        actions: <Widget>[
          // action button
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Round round = new Round((b) => b
                ..teamAScore = 0
                ..teamBScore = 0
                ..numHands = 0
                ..lastPlayed = DateTime.now());

              DocumentReference roundReference =
                  matchReference.collection("rounds").document();
              roundReference.setData(round.toMap());
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        RoundScreen(matchReference, roundReference)),
              );
            },
          ),
        ],
      ),
      body: _buildBody(context, match),
    );
  }

  Widget _buildBody(BuildContext context, Match match) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: <Widget>[
          _buildHeader(context, match),
          Row(
            children: [
              Expanded(
                child: Text(
                  "Rounds",
                  textAlign: TextAlign.left,
                  style: Theme.of(context).textTheme.subhead,
                ),
              ),
            ],
          ),
          Divider(
            color: Theme.of(context).dividerColor,
            height: 0.0,
          ),
          Flexible(
            child: StreamBuilder<QuerySnapshot>(
              stream: matchReference
                  .collection("rounds")
                  .orderBy("lastPlayed")
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return LinearProgressIndicator();

                return _buildList(context, match, snapshot.data.documents);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, Match match) {
    TextStyle mainStyle = Theme.of(context).textTheme.title;
    int nameFlex = 5;
    int winsFlex = 1;
    return Padding(
      padding: EdgeInsets.only(top: 12.0, bottom: 24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            flex: nameFlex,
            child: Text(
              match.teamA.name,
              textAlign: TextAlign.left,
              overflow: TextOverflow.ellipsis,
              style: mainStyle,
            ),
          ),
          Expanded(
            flex: winsFlex,
            child: Text(
              "${match.teamA.wins}",
              textAlign: TextAlign.right,
              style: mainStyle,
            ),
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
            child: Text(
              "${match.teamB.wins}",
              textAlign: TextAlign.left,
              style: mainStyle,
            ),
          ),
          Expanded(
            flex: nameFlex,
            child: Text(
              match.teamB.name,
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis,
              style: mainStyle,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildList(
      BuildContext context, Match match, List<DocumentSnapshot> snapshot) {
    return ListView.separated(
      separatorBuilder: (context, index) => Divider(
            color: Colors.grey,
            height: 0.0,
          ),
      itemCount: snapshot.length,
      itemBuilder: (context, index) =>
          _buildListItem(context, match, snapshot[index]),
    );
  }

  Widget _buildListItem(
      BuildContext context, Match match, DocumentSnapshot roundSnapshot) {
    final round = Round.fromMap(roundSnapshot.data);
    final roundReference = roundSnapshot.reference;

    TextStyle mainStyle = Theme.of(context).textTheme.subhead;
    int winsFlex = 1;

    return Dismissible(
      background: new LeaveBehindWidget(alignment: Alignment.centerLeft),
      secondaryBackground:
          new LeaveBehindWidget(alignment: Alignment.centerRight),
      key: Key(round.toString()),
      onDismissed: (direction) {
        roundReference.delete();

        // Show a snackbar! This snackbar could also contain "Undo" actions.
        Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Text("Round Deleted"),
            action: SnackBarAction(
              label: 'Undo',
              onPressed: () => Firestore.instance
                  .document(roundReference.path)
                  .setData(roundSnapshot.data),
            ),
          ),
        );
      },
      child: InkWell(
        onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      RoundScreen(matchReference, roundReference)),
            ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    flex: winsFlex,
                    child: Text(
                      "${round.teamAScore}",
                      textAlign: TextAlign.right,
                      style: mainStyle,
                    ),
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
                    child: Text(
                      "${round.teamBScore}",
                      textAlign: TextAlign.left,
                      style: mainStyle,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 6.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        DateFormat.yMMMd().format(round.lastPlayed),
                        textAlign: TextAlign.right,
                        style: Theme.of(context).textTheme.caption,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
