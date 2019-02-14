import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'common_widgets.dart';
import 'model/match.dart';
import 'model/round.dart';
import 'round_screen.dart';

class MatchScreen extends StatefulWidget {
  final Match match;

  MatchScreen(this.match);

  @override
  _MatchScreenState createState() {
    return _MatchScreenState(this.match);
  }
}

class _MatchScreenState extends State<MatchScreen> {
  final Match match;

  _MatchScreenState(this.match);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("${match.teamA.name} vs ${match.teamB.name}")),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: <Widget>[
          _buildHeader(context),
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
              stream: Firestore.instance
                  .collection('matches')
                  .document(match.reference.documentID)
                  .collection("rounds")
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return LinearProgressIndicator();

                return _buildList(context, snapshot.data.documents);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
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

  Widget _buildListItem(BuildContext context, DocumentSnapshot snapshot) {
    final round = Round.fromSnapshot(snapshot);

    TextStyle mainStyle = Theme.of(context).textTheme.subhead;
    int winsFlex = 1;

    return Dismissible(
      background: new LeaveBehindWidget(alignment: Alignment.centerLeft),
      secondaryBackground:
          new LeaveBehindWidget(alignment: Alignment.centerRight),
      key: Key(round.toString()),
      onDismissed: (direction) {
        setState(() {
          snapshot.reference.delete();
        });

        // Show a snackbar! This snackbar could also contain "Undo" actions.
        Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Text("Round Deleted"),
            action: SnackBarAction(
              label: 'Undo',
              onPressed: () => Firestore.instance
                  .document(snapshot.reference.path)
                  .setData(snapshot.data),
            ),
          ),
        );
      },
      child: InkWell(
        onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => RoundScreen(match, round)),
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
                        DateFormat.yMMMd().format(match.lastPlayed),
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
