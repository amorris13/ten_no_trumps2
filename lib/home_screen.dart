import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'common_widgets.dart';
import 'match_screen.dart';
import 'model/match.dart';
import 'new_match_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('500 Scorer'),
        actions: <Widget>[
          // action button
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NewMatchScreen()),
                ),
          ),
        ],
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    _auth.currentUser().then((user) {
      if (user != null) {
        // send the user to the home page
        // homePage();
      } else {
        _auth.signInAnonymously();
      }
    });

    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('matches').snapshots(),
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

  Widget _buildListItem(BuildContext context, DocumentSnapshot snapshot) {
    final match = Match.fromMap(snapshot.data);

    TextStyle mainStyle = Theme.of(context).textTheme.subhead;
    int nameFlex = 5;
    int winsFlex = 1;
    return Dismissible(
      background: new LeaveBehindWidget(alignment: Alignment.centerLeft),
      secondaryBackground:
          new LeaveBehindWidget(alignment: Alignment.centerRight),
      key: Key(match.toString()),
      onDismissed: (direction) {
        setState(() {
          snapshot.reference.delete();
        });

        // Show a snackbar! This snackbar could also contain "Undo" actions.
        Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Text("Match Deleted"),
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
                  builder: (context) => MatchScreen(snapshot.reference)),
            ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
          child: Column(
            children: <Widget>[
              Row(
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
