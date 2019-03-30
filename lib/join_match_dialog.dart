import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quiver/strings.dart';
import 'package:rxdart/rxdart.dart';

import 'match_screen.dart';
import 'model/match.dart';

class JoinMatchDialog extends StatefulWidget {
  final FirebaseUser currentUser;

  JoinMatchDialog(this.currentUser);

  @override
  State<StatefulWidget> createState() => _JoinMatchDialogState();
}

class _JoinMatchDialogState extends State<JoinMatchDialog> {
  BehaviorSubject<String> matchCodeSubject;
  Observable<Result> matchDocumentSnapshotStream;

  @override
  void initState() {
    super.initState();
    matchCodeSubject = BehaviorSubject.seeded(null);
    matchDocumentSnapshotStream = Observable(matchCodeSubject.stream)
        .distinct()
        .doOnData((data) => print("matchCodeStream: $data"))
        .switchMap((String matchCode) => docSnapshotForMatchCode(matchCode))
        .doOnData((data) => print("matchDocumentSnapshotStream: $data"))
        .asBroadcastStream();
  }

  @override
  void dispose() {
    super.dispose();
    matchCodeSubject.close();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Join match"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextField(
            decoration: InputDecoration(labelText: "Match Code"),
            textCapitalization: TextCapitalization.characters,
            onChanged: (String value) {
              matchCodeSubject.add(null);
            },
            onSubmitted: (String value) {
              matchCodeSubject.add(value);
            },
          ),
          StreamBuilder(
            stream: matchDocumentSnapshotStream,
            builder: (BuildContext context, AsyncSnapshot<Result> snapshot) {
              Widget child = getMatchWidget(context, snapshot);

              return Container(
                height: 60.0,
                alignment: Alignment.topCenter,
                padding: const EdgeInsets.only(top: 24.0),
                child: child,
              );
            },
          ),
        ],
      ),
      actions: <Widget>[
        FlatButton(
          child: Text('Cancel'),
          onPressed: () => Navigator.of(context).pop(),
        ),
        StreamBuilder(
          stream: matchDocumentSnapshotStream,
          builder: (BuildContext context, AsyncSnapshot<Result> snapshot) {
            return FlatButton(
              child: Text('Join'),
              onPressed: snapshot.hasData &&
                      snapshot.data.status == Status.FETCHED &&
                      snapshot.data.documentSnapshot != null
                  ? () {
                      String uid = widget.currentUser.uid;
                      DocumentSnapshot documentSnapshot =
                          snapshot.data.documentSnapshot;
                      Match match = Match.fromMap(documentSnapshot.data);
                      MatchBuilder matchBuilder = match.toBuilder();
                      if (!match.users.contains(uid)) {
                        matchBuilder.users.add(uid);
                      }
                      Match updatedMatch = matchBuilder.build();
                      documentSnapshot.reference.setData(updatedMatch.toMap());

                      DocumentReference userReference = Firestore.instance
                          .collection('users')
                          .document(widget.currentUser.uid);
                      Navigator.pushReplacementNamed(
                          context, MatchScreen.routeName,
                          arguments: MatchScreenArguments(
                              documentSnapshot.reference, userReference));
                    }
                  : null,
            );
          },
        ),
      ],
    );
  }

  Widget getMatchWidget(BuildContext context, AsyncSnapshot<Result> snapshot) {
    if (!snapshot.hasData) {
      return null;
    }

    switch (snapshot.data.status) {
      case Status.FETCHING:
        return CircularProgressIndicator();
      case Status.FETCHED:
        if (snapshot.data.documentSnapshot == null) {
          return Text("No match found");
        }

        Match match = Match.fromMap(snapshot.data.documentSnapshot.data);
        return DefaultTextStyle(
          style: Theme.of(context)
              .textTheme
              .body2
              .copyWith(fontWeight: FontWeight.w600),
          child: MatchScreen.buildHeader(context, match),
        );
      case Status.IDLE:
        return null;
      default:
        throw Error();
    }
  }

  static Stream<Result> docSnapshotForMatchCode(String matchCode) {
    if (isEmpty(matchCode)) {
      return Observable.just(Result(Status.IDLE, null));
    }

    Future<Result> result = Firestore.instance
        .collection("matches")
        .where("code", isEqualTo: matchCode)
        .getDocuments()
        .then((querySnapshot) {
      if (querySnapshot.documents.isEmpty) {
        return Result(Status.FETCHED, null);
      } else {
        return Result(Status.FETCHED, querySnapshot.documents.first);
      }
    });
    return Observable.fromFuture(result)
        .startWith(Result(Status.FETCHING, null));
  }
}

enum Status {
  IDLE,
  FETCHING,
  FETCHED,
}

class Result {
  Status status;
  DocumentSnapshot documentSnapshot;

  Result(this.status, this.documentSnapshot);
}
