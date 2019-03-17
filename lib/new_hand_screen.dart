import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quiver/collection.dart';
import 'package:rxdart/rxdart.dart';

import 'formatters.dart';
import 'model/bid.dart';
import 'model/hand.dart';
import 'model/match.dart';
import 'model/round.dart';
import 'model/scoring.dart';

class NewHandScreen extends StatefulWidget {
  final DocumentReference matchReference;
  final DocumentReference roundReference;

  NewHandScreen(this.matchReference, this.roundReference);

  @override
  _NewHandScreenState createState() {
    return _NewHandScreenState(matchReference, roundReference);
  }
}

class _NewHandScreenState extends State<NewHandScreen> {
  final _formKey = GlobalKey<FormState>();
  final DocumentReference matchReference;
  final DocumentReference roundReference;

  HandBuilder handBuilder = HandBuilder();

  _NewHandScreenState(this.matchReference, this.roundReference);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("New Hand")),
      body: StreamBuilder<Snapshots>(
        stream: Observable.combineLatest2(
            matchReference.snapshots(),
            roundReference.snapshots(),
            (matchSnapshot, roundSnapshot) =>
                Snapshots(matchSnapshot, roundSnapshot)),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return LinearProgressIndicator();

          return _buildBody(
              context,
              Match.fromMap(snapshot.data.matchSnapshot.data),
              Round.fromMap(snapshot.data.roundSnapshot.data));
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context, Match match, Round round) {
    var entries = <Widget>[];
    BehaviorSubject<int> biddingTeamSubject = BehaviorSubject();
    entries.addAll([
      new SectionTitle("Bidding Team"),
      FormField<int>(
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
          rows.add(Row(
              children: Iterable.generate(Match.NUM_TEAMS)
                  .map((teamNumber) => teamButton(
                      context,
                      state,
                      match.getTeam(teamNumber),
                      teamNumber,
                      biddingTeamSubject))
                  .toList()));
          if (state.hasError) {
            rows.add(new ErrorWidget(state.errorText));
          }
          return Column(children: rows);
        },
      ),
    ]);

    if (match.hasPlayerNames()) {
      entries.addAll([
        new SectionTitle("Bidding Player"),
        StreamBuilder<int>(
            stream: biddingTeamSubject.stream,
            builder: (context, biddingTeam) {
              int biddingTeamNumber = biddingTeam.data;
              print("bidding player builder. bidding team: $biddingTeamNumber");

              return FormField<int>(
                initialValue: null,
                onSaved: (player) {
                  handBuilder.biddingPlayer = player;
                },
                builder: (FormFieldState<int> state) {
                  if (state.value != null) {
                    if (!Match.isPlayerOnTeam(biddingTeamNumber, state.value)) {
                      state.reset();
                    }
                  }
                  var rows = <Widget>[];
                  rows.add(Row(
                    children: Iterable.generate(Match.NUM_TEAMS)
                        .map((teamNumber) => playerColumn(
                            context,
                            state,
                            match.getTeam(teamNumber),
                            teamNumber,
                            biddingTeamNumber))
                        .toList(),
                  ));
                  if (state.hasError) {
                    rows.add(new ErrorWidget(state.errorText));
                  }
                  return Column(children: rows);
                },
              );
            })
      ]);
    }

    BehaviorSubject<Bid> bidSubject = BehaviorSubject();
    entries.addAll([
      new SectionTitle("Bids"),
      FormField<Bid>(
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
                        Bid newBid = isSelected ? null : bid;
                        state.didChange(newBid);
                        bidSubject.add(newBid);
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
      )
    ]);

    BehaviorSubject<int> tricksWonSubject = BehaviorSubject();
    entries.addAll([
      new SectionTitle("Tricks Won"),
      FormField<int>(
        initialValue: 0,
        validator: (tricksWon) {
          if (tricksWon == null) {
            return 'Tricks Won must be set';
          }
        },
        onSaved: (tricksWon) {
          handBuilder.tricksWon = tricksWon;
        },
        builder: (FormFieldState<int> state) {
          var rows = <Widget>[];
          rows.add(Row(children: <Widget>[
            Expanded(
              child: SliderTheme(
                data: SliderTheme.of(context)
                    .copyWith(showValueIndicator: ShowValueIndicator.always),
                child: Slider(
                    min: 0.0,
                    max: Bid.TRICKS_PER_HAND.toDouble(),
                    value: state.value.toDouble(),
                    label: state.value.toString(),
                    onChanged: (value) {
                      int tricksWon = value.toInt();
                      state.didChange(tricksWon);
                      tricksWonSubject.add(tricksWon);
                    },
                    divisions: Bid.TRICKS_PER_HAND),
              ),
            ),
            Text(state.value.toString()),
          ]));
          if (state.hasError) {
            rows.add(new ErrorWidget(state.errorText));
          }
          return Column(children: rows);
        },
      ),
    ]);

    Scoring scoring = Scoring(round.scoringPrefsNonNull);
    entries.add(
      StreamBuilder<BidSummary>(
        stream: Observable.combineLatest3(
            biddingTeamSubject.stream,
            bidSubject.stream,
            tricksWonSubject.stream,
            (biddingTeam, bid, tricksWon) =>
                BidSummary(biddingTeam, bid, tricksWon)),
        builder: (context, snapshot) {
          BidSummary bidSummary = snapshot.data;
          return Row(
              children: Iterable.generate(Match.NUM_TEAMS).map((teamNumber) {
            TextStyle style = Theme.of(context).textTheme.title;
            if (bidSummary == null || !bidSummary.allSet()) {
              return Expanded(
                child: Text(
                  "-",
                  style: style,
                  textAlign: TextAlign.center,
                ),
              );
            }
            bool biddingTeam = teamNumber == bidSummary.biddingTeam;
            int points = scoring.calcScore(teamNumber == bidSummary.biddingTeam,
                bidSummary.bid, bidSummary.tricksWon);
            return Expanded(
              child: Text(
                Formatters.formatPoints(points),
                style: style.apply(
                  color: Formatters.getColor(points, biddingTeam),
                ),
                textAlign: TextAlign.center,
              ),
            );
          }).toList());
        },
      ),
    );

    entries.add(Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: OutlineButton(
        onPressed: () {
          // Validate will return true if the form is valid, or false if
          // the form is invalid.
          if (_formKey.currentState.validate()) {
            _formKey.currentState.save();

            handBuilder.pointsTeamA = scoring.calcScore(
                handBuilder.biddingTeam == 0,
                bidSubject.value,
                tricksWonSubject.value);
            handBuilder.cumPointsTeamA =
                round.teamAScore + handBuilder.pointsTeamA;
            handBuilder.pointsTeamB = scoring.calcScore(
                handBuilder.biddingTeam == 1,
                bidSubject.value,
                tricksWonSubject.value);
            handBuilder.cumPointsTeamB =
                round.teamBScore + handBuilder.pointsTeamB;
            handBuilder.timePlayed = DateTime.now();
            handBuilder.handNumber = round.numHands;

            Hand hand = handBuilder.build();

            DocumentReference handReference =
                roundReference.collection("hands").document();
            handReference.setData(hand.toMap());

            RoundBuilder roundBuilder = round.toBuilder()
              ..teamAScore = hand.cumPointsTeamA
              ..teamBScore = hand.cumPointsTeamB
              ..lastPlayed = hand.timePlayed
              ..numHands += 1;
            [0, 1].forEach((teamNumber) {
              if (scoring.hasWon(
                  hand.biddingTeam == teamNumber,
                  hand.getCumPoints(teamNumber),
                  hand.getCumPoints(1 - teamNumber))) {
                roundBuilder.winningTeam = teamNumber;
                roundBuilder.finished = true;
              }
            });
            roundReference.setData(roundBuilder.build().toMap(), merge: true);

            MatchBuilder matchBuilder = match.toBuilder()
              ..lastPlayed = hand.timePlayed;
            if (round.finished) {
              Match.getTeamBuilder(matchBuilder, round.winningTeam).wins++;
            }
            matchReference.setData(matchBuilder.build().toMap(), merge: true);

            Navigator.pop(context);
          }
        },
        child: Text('OK'),
      ),
    ));
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: entries,
          ),
        ),
      ),
    );
  }

  Expanded teamButton(BuildContext context, FormFieldState<int> state,
      Team team, int teamNumber, Subject<int> biddingTeamSubject) {
    bool isSelected = state.value == teamNumber;
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.0),
        child: SelectionButton(
          onPressed: () {
            var biddingTeam = isSelected ? null : teamNumber;
            state.didChange(biddingTeam);
            biddingTeamSubject.add(biddingTeam);
          },
          isSelected: isSelected,
          text: team.name,
        ),
      ),
    );
  }

  Widget playerColumn(BuildContext context, FormFieldState<int> state,
      Team team, int teamNumber, int biddingTeamNumber) {
    bool enabled = biddingTeamNumber == teamNumber;
    return Expanded(
      child: Column(
        children: Iterable.generate(Team.NUM_PLAYERS)
            .map((playerWithinTeamNumber) => playerButton(
                context,
                state,
                team.getPlayerName(playerWithinTeamNumber),
                Match.getPlayerNumber(teamNumber, playerWithinTeamNumber),
                enabled))
            .toList(),
      ),
    );
  }

  Widget playerButton(BuildContext context, FormFieldState<int> state,
      String playerName, int playerNumber, bool enabled) {
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
              enabled: enabled,
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
    this.enabled = true,
  }) : super(key: key);

  final VoidCallback onPressed;
  final bool isSelected;
  final String text;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return OutlineButton(
      onPressed: enabled ? onPressed : null,
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

class Snapshots {
  final DocumentSnapshot matchSnapshot;
  final DocumentSnapshot roundSnapshot;

  Snapshots(this.matchSnapshot, this.roundSnapshot);
}

class BidSummary {
  final int biddingTeam;
  final Bid bid;
  final int tricksWon;

  BidSummary(this.biddingTeam, this.bid, this.tricksWon);

  bool allSet() {
    return biddingTeam != null && bid != null && tricksWon != null;
  }
}
