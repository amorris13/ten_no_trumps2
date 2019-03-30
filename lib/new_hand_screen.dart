import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quiver/collection.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tuple/tuple.dart';

import 'formatters.dart';
import 'model/bid.dart';
import 'model/hand.dart';
import 'model/match.dart';
import 'model/round.dart';
import 'model/scoring.dart';

class NewHandScreenArguments {
  final DocumentReference matchReference;
  final DocumentReference roundReference;

  NewHandScreenArguments(this.matchReference, this.roundReference);
}

class NewHandScreen extends StatefulWidget {
  static const String routeName = "/match/round/newHand";

  final DocumentReference matchReference;
  final DocumentReference roundReference;

  NewHandScreen(this.matchReference, this.roundReference);

  NewHandScreen.fromArgs(NewHandScreenArguments args)
      : this.matchReference = args.matchReference,
        this.roundReference = args.roundReference;

  @override
  _NewHandScreenState createState() {
    return _NewHandScreenState();
  }
}

class _NewHandScreenState extends State<NewHandScreen> {
  BehaviorSubject<int> biddingTeamSubject;
  BehaviorSubject<int> biddingPlayerSubject;
  BehaviorSubject<Bid> bidSubject;
  BehaviorSubject<int> tricksWonSubject;

  @override
  void initState() {
    super.initState();
    biddingTeamSubject = BehaviorSubject.seeded(null);
    biddingPlayerSubject = BehaviorSubject.seeded(null);
    bidSubject = BehaviorSubject.seeded(null);
    tricksWonSubject = BehaviorSubject.seeded(null);
  }

  @override
  void dispose() {
    super.dispose();
    biddingTeamSubject.close();
    biddingPlayerSubject.close();
    bidSubject.close();
    tricksWonSubject.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("New Hand")),
      body: StreamBuilder<Snapshots>(
        stream: Observable.combineLatest2(
            widget.matchReference.snapshots(),
            widget.roundReference.snapshots(),
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
    entries.addAll([
      new SectionTitle("Bidding Team"),
      StreamBuilder(
        stream: biddingTeamSubject.stream,
        builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
          return Row(
              children: Iterable.generate(Match.NUM_TEAMS)
                  .map((teamNumber) => teamButton(
                        context,
                        snapshot.data,
                        match.getTeam(teamNumber),
                        teamNumber,
                      ))
                  .toList());
        },
      ),
    ]);

    if (match.hasPlayerNames()) {
      entries.addAll([
        new SectionTitle("Bidding Player"),
        StreamBuilder<Tuple2<int, int>>(
            stream: Observable.combineLatest2(
                biddingTeamSubject.stream,
                biddingPlayerSubject.stream,
                (biddingTeam, biddingPlayer) =>
                    Tuple2<int, int>(biddingTeam, biddingPlayer)),
            builder: (context, snapshot) {
              int biddingTeamNumber = snapshot.data?.item1;
              int biddingPlayerNumber = snapshot.data?.item2;
              if (biddingPlayerNumber != null) {
                if (!Match.isPlayerOnTeam(
                    biddingTeamNumber, biddingPlayerNumber)) {
                  biddingPlayerSubject.add(null);
                }
              }
              return Row(
                  children: Iterable.generate(Match.NUM_TEAMS)
                      .map((teamNumber) => playerColumn(
                          context,
                          biddingPlayerNumber,
                          match.getTeam(teamNumber),
                          teamNumber,
                          biddingTeamNumber))
                      .toList());
            }),
      ]);
    }

    entries.addAll([
      new SectionTitle("Bids"),
      StreamBuilder(
        stream: bidSubject.stream,
        builder: (context, snapshot) {
          Bid currentBid = snapshot.data;
          Multimap<Tricks, Bid> bidsByTricks = Multimap.fromIterable(Bid.BIDS,
              key: (bid) => bid.tricks, value: (bid) => bid);
          var rows = <Widget>[];
          bidsByTricks.forEachKey((tricks, bids) {
            var buttons = <Widget>[];
            bids.forEach((bid) {
              bool isSelected = currentBid == bid;
              buttons.add(Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.0),
                  child: new SelectionButton(
                      isSelected: isSelected,
                      onPressed: () {
                        Bid newBid = isSelected ? null : bid;
                        bidSubject.add(newBid);
                      },
                      text: bid.getSymbol()),
                ),
              ));
            });
            rows.add(Row(children: buttons));
          });
          return Column(children: rows);
        },
      )
    ]);

    entries.addAll([
      new SectionTitle("Tricks Won"),
      StreamBuilder(
        stream: tricksWonSubject.stream,
        builder: (context, snapshot) {
          int currentTricksWon = snapshot.data ?? 0;
          return Row(children: <Widget>[
            Expanded(
              child: SliderTheme(
                data: SliderTheme.of(context)
                    .copyWith(showValueIndicator: ShowValueIndicator.always),
                child: Slider(
                    min: 0.0,
                    max: Bid.TRICKS_PER_HAND.toDouble(),
                    value: currentTricksWon.toDouble(),
                    label: currentTricksWon.toString(),
                    onChanged: (value) {
                      int tricksWon = value.toInt();
                      tricksWonSubject.add(tricksWon);
                    },
                    divisions: Bid.TRICKS_PER_HAND),
              ),
            ),
            Text(currentTricksWon.toString()),
          ]);
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
      child: StreamBuilder(
          stream: Observable.combineLatest3(
              biddingTeamSubject.stream,
              bidSubject.stream,
              tricksWonSubject.stream,
              (biddingTeam, bid, tricksWon) =>
                  biddingTeam != null && bid != null && tricksWon != null),
          builder: (context, snapshot) {
            return OutlineButton(
              onPressed: snapshot.hasData && snapshot.data
                  ? () {
                      createHand(scoring, round, match);
                      Navigator.pop(context);
                    }
                  : null,
              child: Text('OK'),
            );
          }),
    ));

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
        child: Column(
          children: entries,
        ),
      ),
    );
  }

  void createHand(Scoring scoring, Round round, Match match) {
    HandBuilder handBuilder = HandBuilder();
    handBuilder.biddingTeam = biddingTeamSubject.value;
    handBuilder.biddingPlayer = biddingPlayerSubject.value;
    handBuilder.tricksWon = tricksWonSubject.value;
    handBuilder.bid = bidSubject.value.toFullString();

    handBuilder.pointsTeamA = scoring.calcScore(biddingTeamSubject.value == 0,
        bidSubject.value, tricksWonSubject.value);
    handBuilder.cumPointsTeamA = round.teamAScore + handBuilder.pointsTeamA;
    handBuilder.pointsTeamB = scoring.calcScore(biddingTeamSubject.value == 1,
        bidSubject.value, tricksWonSubject.value);
    handBuilder.cumPointsTeamB = round.teamBScore + handBuilder.pointsTeamB;
    handBuilder.timePlayed = DateTime.now();
    handBuilder.handNumber = round.numHands;

    Hand hand = handBuilder.build();

    DocumentReference handReference =
        widget.roundReference.collection("hands").document();
    handReference.setData(hand.toMap());

    RoundBuilder roundBuilder = round.toBuilder()
      ..teamAScore = hand.cumPointsTeamA
      ..teamBScore = hand.cumPointsTeamB
      ..lastPlayed = hand.timePlayed
      ..numHands += 1;
    [0, 1].forEach((teamNumber) {
      if (scoring.hasWon(hand.biddingTeam == teamNumber,
          hand.getCumPoints(teamNumber), hand.getCumPoints(1 - teamNumber))) {
        roundBuilder.winningTeam = teamNumber;
        roundBuilder.finished = true;
      }
    });
    Round updatedRound = roundBuilder.build();
    widget.roundReference.setData(updatedRound.toMap(), merge: true);

    MatchBuilder matchBuilder = match.toBuilder()..lastPlayed = hand.timePlayed;
    if (updatedRound.finished) {
      TeamBuilder teamBuilder =
          Match.getTeamBuilder(matchBuilder, updatedRound.winningTeam);
      teamBuilder.wins += 1;
    }
    Match updatedMatch = matchBuilder.build();
    widget.matchReference.setData(updatedMatch.toMap(), merge: true);
  }

  Expanded teamButton(
      BuildContext context, int biddingTeamNumber, Team team, int teamNumber) {
    bool isSelected = biddingTeamNumber == teamNumber;
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.0),
        child: SelectionButton(
          onPressed: () {
            var biddingTeam = isSelected ? null : teamNumber;
            biddingTeamSubject.add(biddingTeam);
          },
          isSelected: isSelected,
          text: team.name,
        ),
      ),
    );
  }

  Widget playerColumn(BuildContext context, int biddingPlayerNumber, Team team,
      int teamNumber, int biddingTeamNumber) {
    bool enabled = biddingTeamNumber == teamNumber;
    return Expanded(
      child: Column(
        children: Iterable.generate(Team.NUM_PLAYERS)
            .map((playerWithinTeamNumber) => playerButton(
                context,
                biddingPlayerNumber,
                team.getPlayerName(playerWithinTeamNumber),
                Match.getPlayerNumber(teamNumber, playerWithinTeamNumber),
                enabled))
            .toList(),
      ),
    );
  }

  Widget playerButton(BuildContext context, int biddingPlayerNumber,
      String playerName, int playerNumber, bool enabled) {
    bool isSelected = biddingPlayerNumber == playerNumber;
    return Row(
      children: <Widget>[
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.0),
            child: SelectionButton(
              onPressed: () {
                biddingPlayerSubject.add(isSelected ? null : playerNumber);
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
