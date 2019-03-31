import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'common_widgets.dart';
import 'join_match_dialog.dart';
import 'login_screen.dart';
import 'match_screen.dart';
import 'model/match.dart';
import 'new_match_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatelessWidget {
  static const String routeName = "/";

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

class HomeScreenArguments {}

class HomeWidget extends StatelessWidget {
  final FirebaseUser user;

  HomeWidget(this.user);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Image.asset('assets/ic-launcher.png'),
        title: Text('500 Scorer'),
        actions: <Widget>[
          // action button
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => Navigator.pushNamed(
                context, NewMatchScreen.routeName,
                arguments: NewMatchScreenArguments(user)),
          ),
          PopupMenuButton<Function>(
            onSelected: (function) => function.call(),
            itemBuilder: (BuildContext context) => <PopupMenuItem<Function>>[
                  PopupMenuItem<Function>(
                    value: () => showDialog(
                          context: context,
                          builder: (context) => JoinMatchDialog(user),
                        ),
                    child: Text('Join match'),
                  ),
                  PopupMenuItem<Function>(
                    value: () =>
                        Navigator.pushNamed(context, SettingsScreen.routeName),
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
    return snapshot.isEmpty
        ? Padding(
            padding: EdgeInsets.only(top: 16.0),
            child: Center(child: Text("Click + to start a match.")))
        : Scrollbar(
            child: ListView.separated(
              separatorBuilder: (context, index) => Divider(
                    color: Theme.of(context).dividerColor,
                    height: 0.0,
                  ),
              itemCount: snapshot.length,
              itemBuilder: (context, index) =>
                  _buildListItem(context, snapshot[index]),
            ),
          );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot snapshot) {
    Match match = Match.fromMap(snapshot.data);
    DocumentReference userReference =
        Firestore.instance.collection('users').document(user.uid);
    TextStyle mainStyle = Theme.of(context).textTheme.subhead;
    int nameFlex = 5;
    int winsFlex = 1;
    return Dismissible(
      background: new LeaveBehindWidget(alignment: Alignment.centerLeft),
      secondaryBackground:
          new LeaveBehindWidget(alignment: Alignment.centerRight),
      key: Key(match.toString()),
      onDismissed: (direction) {
        if (match.users.length == 1) {
          snapshot.reference.delete();
        } else {
          MatchBuilder matchBuilder = match.toBuilder();
          matchBuilder.users.remove(user.uid);
          Match updatedMatch = matchBuilder.build();
          snapshot.reference.setData(updatedMatch.toMap());
        }

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
        onTap: () => Navigator.pushNamed(context, MatchScreen.routeName,
            arguments: MatchScreenArguments(snapshot.reference, userReference)),
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
