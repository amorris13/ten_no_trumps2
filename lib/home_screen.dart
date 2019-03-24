import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'common_widgets.dart';
import 'login_screen.dart';
import 'match_screen.dart';
import 'model/match.dart';
import 'new_match_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<FirebaseUser>(
      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LoginScreen();

        return HomeWidget(snapshot.data);
      },
    );
  }
}

class HomeWidget extends StatelessWidget {
  final FirebaseUser user;

  HomeWidget(this.user);

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
                  MaterialPageRoute(builder: (context) => NewMatchScreen(user)),
                ),
          ),
          PopupMenuButton<Function>(
            onSelected: (function) => function.call(),
            itemBuilder: (BuildContext context) => <PopupMenuItem<Function>>[
                  PopupMenuItem<Function>(
                    value: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SettingsScreen()),
                        ),
                    child: Text('Settings'),
                  ),
                ],
          ),
        ],
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
          .collection('matches')
          .where("users", arrayContains: user.uid)
          .orderBy("lastPlayed", descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();

        return _buildList(context, snapshot.data.documents);
      },
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView.separated(
      separatorBuilder: (context, index) => Divider(
            color: Theme.of(context).dividerColor,
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
        snapshot.reference.delete();

        Scaffold.of(context).hideCurrentSnackBar();
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
                  builder: (context) => MatchScreen(
                        snapshot.reference,
                        Firestore.instance
                            .collection('users')
                            .document(user.uid),
                      )),
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
