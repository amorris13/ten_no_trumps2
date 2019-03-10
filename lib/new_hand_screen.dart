import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quiver/collection.dart';

import 'model/bid.dart';
import 'model/hand.dart';
import 'model/match.dart';

class NewHandScreen extends StatefulWidget {
  final DocumentReference matchReference;
  final DocumentReference roundReference;

  NewHandScreen(this.matchReference, this.roundReference);

  @override
  _NewHandScreenState createState() {
    return _NewHandScreenState(matchReference);
  }
}

class _NewHandScreenState extends State<NewHandScreen> {
  final _formKey = GlobalKey<FormState>();
  final DocumentReference matchReference;

  HandBuilder handBuilder = HandBuilder();

  _NewHandScreenState(this.matchReference);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("New Hand")),
      body: StreamBuilder<DocumentSnapshot>(
        stream: matchReference.snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return LinearProgressIndicator();

          return _buildBody(context, Match.fromMap(snapshot.data.data));
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context, Match match) {
    var biddingTeamField = FormField<int>(
      initialValue: null,
      validator: (team) {
        if (team == null) {
          return 'Team must be set';
        }
      },
      onSaved: (team) {
        handBuilder.biddingTeam = team;
      },
      builder: (FormFieldState<int> state) {
        var rows = <Widget>[];
        rows.add(Row(children: <Widget>[
          teamButton(state, match.teamA, 0, context),
          teamButton(state, match.teamB, 1, context),
        ]));
        if (state.hasError) {
          rows.add(new ErrorWidget(state.errorText));
        }
        return Column(children: rows);
      },
    );

    var biddingPlayerField = FormField<int>(
      initialValue: null,
      onSaved: (player) {
        handBuilder.biddingPlayer = player;
      },
      builder: (FormFieldState<int> state) {
        var rows = <Widget>[];
        rows.add(Row(
          children: <Widget>[
            playerColumn(state, match.teamA, 0, context),
            playerColumn(state, match.teamB, 1, context),
          ],
        ));
        if (state.hasError) {
          rows.add(new ErrorWidget(state.errorText));
        }
        return Column(children: rows);
      },
    );

    var bidsField = FormField<Bid>(
      initialValue: null,
      validator: (bid) {
        if (bid == null) {
          return 'Bid must be set';
        }
      },
      onSaved: (bid) {
        handBuilder.bid = bid.toFullString();
      },
      builder: (FormFieldState<Bid> state) {
        Multimap<Tricks, Bid> bidsByTricks = Multimap.fromIterable(Bid.BIDS,
            key: (bid) => bid.tricks, value: (bid) => bid);
        var rows = <Widget>[];
        bidsByTricks.forEachKey((tricks, bids) {
          var buttons = <Widget>[];
          bids.forEach((bid) {
            bool isSelected = state.value == bid;
            buttons.add(Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.0),
                child: new SelectionButton(
                    isSelected: isSelected,
                    onPressed: () {
                      state.didChange(isSelected ? null : bid);
                    },
                    text: bid.getSymbol()),
              ),
            ));
          });
          rows.add(Row(children: buttons));
        });
        if (state.hasError) {
          rows.add(new ErrorWidget(state.errorText));
        }
        return Column(children: rows);
      },
    );

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              new SectionTitle("Bidding Team"),
              biddingTeamField,
              new SectionTitle("Bidding Player"),
              biddingPlayerField,
              new SectionTitle("Bids"),
              bidsField,
              new SectionTitle("Tricks Won"),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: OutlineButton(
                  onPressed: () {
                    // Validate will return true if the form is valid, or false if
                    // the form is invalid.
                    if (_formKey.currentState.validate()) {
                      _formKey.currentState.save();
                      // matchBuilder.lastPlayed = DateTime.now();
                      // matchBuilder.teamA.wins = 0;
                      // matchBuilder.teamB.wins = 0;

                      // DocumentReference matchReference =
                      //     Firestore.instance.collection("matches").document();
                      // matchReference.setData(matchBuilder.build().toMap());
                      // Navigator.pushReplacement(
                      //   context,
                      //   MaterialPageRoute(
                      //       builder: (context) => MatchScreen(matchReference)),
                      // );
                    }
                  },
                  child: Text('OK'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Expanded teamButton(FormFieldState<int> state, Team team, int teamNumber,
      BuildContext context) {
    bool isSelected = state.value == teamNumber;
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.0),
        child: SelectionButton(
          onPressed: () {
            state.didChange(isSelected ? null : teamNumber);
          },
          isSelected: isSelected,
          text: team.name,
        ),
      ),
    );
  }

  Widget playerColumn(FormFieldState<int> state, Team team, int playerOffset,
      BuildContext context) {
    return Expanded(
      child: Column(children: <Widget>[
        playerButton(state, team.player1, playerOffset + 0, context),
        playerButton(state, team.player2, playerOffset + 2, context),
      ]),
    );
  }

  Widget playerButton(FormFieldState<int> state, String playerName,
      int playerNumber, BuildContext context) {
    bool isSelected = state.value == playerNumber;
    return Row(
      children: <Widget>[
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.0),
            child: SelectionButton(
              onPressed: () {
                state.didChange(isSelected ? null : playerNumber);
              },
              isSelected: isSelected,
              text: playerName,
            ),
          ),
        ),
      ],
    );
  }
}

class SelectionButton extends StatelessWidget {
  const SelectionButton({
    Key key,
    @required this.onPressed,
    @required this.text,
    @required this.isSelected,
  }) : super(key: key);

  final VoidCallback onPressed;
  final bool isSelected;
  final String text;

  @override
  Widget build(BuildContext context) {
    return OutlineButton(
      onPressed: onPressed,
      padding: const EdgeInsets.all(0.0),
      child: Text(text, maxLines: 1),
      borderSide: isSelected
          ? BorderSide(width: 3.0, color: Theme.of(context).primaryColor)
          : null,
    );
  }
}

class SectionTitle extends StatelessWidget {
  const SectionTitle(
    this.title, {
    Key key,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.subtitle,
      ),
    );
  }
}

class ErrorWidget extends StatelessWidget {
  const ErrorWidget(
    this.errorText, {
    Key key,
  }) : super(key: key);

  final String errorText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              errorText,
              style: TextStyle(color: Theme.of(context).errorColor),
              textAlign: TextAlign.left,
            ),
          ),
        ],
      ),
    );
  }
}
