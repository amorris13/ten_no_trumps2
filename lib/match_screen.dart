import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tuple/tuple.dart';

import 'common_widgets.dart';
import 'model/match.dart';
import 'model/round.dart';
import 'model/user.dart';
import 'round_screen.dart';

class MatchScreenArguments {
  final DocumentReference matchReference;
  final DocumentReference userReference;

  MatchScreenArguments(this.matchReference, this.userReference);
}

class MatchScreen extends StatelessWidget {
  static const String routeName = "/match";

  final DocumentReference matchReference;
  final DocumentReference userReference;

  MatchScreen(this.matchReference, this.userReference);

  MatchScreen.fromArgs(MatchScreenArguments args)
      : this.matchReference = args.matchReference,
        this.userReference = args.userReference;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Tuple2>(
      stream: Observable.combineLatest2(
          matchReference.snapshots(),
          userReference.snapshots(),
          (matchSnapshot, userSnapshot) => Tuple2(matchSnapshot, userSnapshot)),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Scaffold(
              appBar: AppBar(title: Text("Match")),
              body: LinearProgressIndicator());
        }

        return _buildScreen(
          context,
          Match.fromMap(snapshot.data.item1.data),
          User.fromMap(snapshot.data.item2.data),
        );
      },
    );
  }

  Widget _buildScreen(BuildContext context, Match match, User user) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Match"),
        actions: <Widget>[
          // action button
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Round round = new Round((b) => b
                ..teamAScore = 0
                ..teamBScore = 0
                ..numHands = 0
                ..finished = false
                ..lastPlayed = DateTime.now());

              DocumentReference roundReference =
                  matchReference.collection("rounds").document();
              roundReference.setData(round.toMap());
              Navigator.pushNamed(
                context,
                RoundScreen.routeName,
                arguments: RoundScreenArguments(
                    userReference, matchReference, roundReference),
              );
            },
          ),
        ],
      ),
      body: _buildBody(context, match),
    );
  }

  Widget _buildBody(BuildContext context, Match match) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        _buildHeader(context, match),
        Divider(height: 0.0),
        Flexible(
          child: StreamBuilder<QuerySnapshot>(
            stream: matchReference
                .collection("rounds")
                .orderBy("lastPlayed", descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return LinearProgressIndicator();

              return _buildList(context, match, snapshot.data.documents);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context, Match match) {
    TextStyle mainStyle = Theme.of(context).textTheme.title;
    int nameFlex = 5;
    int winsFlex = 1;
    return Padding(
      padding:
          EdgeInsets.only(top: 12.0, bottom: 24.0, left: 16.0, right: 16.0),
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
            color: Theme.of(context).dividerColor,
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

    TextStyle mainStyle = Theme.of(context)
        .textTheme
        .subhead
        .apply(fontWeightDelta: round.finished ? 0 : 3);
    int winsFlex = 1;

    return Dismissible(
      background: new LeaveBehindWidget(alignment: Alignment.centerLeft),
      secondaryBackground:
          new LeaveBehindWidget(alignment: Alignment.centerRight),
      key: Key(round.toString()),
      onDismissed: (direction) {
        roundReference.delete();
        MatchBuilder matchBuilder = match.toBuilder();
        if (round.finished) {
          Match.getTeamBuilder(matchBuilder, round.winningTeam).wins--;
        }
        matchReference.setData(matchBuilder.build().toMap(), merge: true);

        Scaffold.of(context).hideCurrentSnackBar();
        Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Text("Round Deleted"),
            action: SnackBarAction(
              label: 'Undo',
              onPressed: () {
                matchReference.get().then((match) {
                  MatchBuilder matchBuilder =
                      Match.fromMap(match.data).toBuilder();
                  if (round.finished) {
                    Match.getTeamBuilder(matchBuilder, round.winningTeam)
                        .wins++;
                  }
                  matchReference.setData(matchBuilder.build().toMap(),
                      merge: true);
                });

                Firestore.instance
                    .document(roundReference.path)
                    .setData(roundSnapshot.data);
              },
            ),
          ),
        );
      },
      child: InkWell(
        onTap: () => Navigator.pushNamed(context, RoundScreen.routeName,
            arguments: RoundScreenArguments(
                userReference, matchReference, roundReference)),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
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
