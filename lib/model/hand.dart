import 'package:cloud_firestore/cloud_firestore.dart';

import 'bid.dart';

class Hand {
  final Bid bid;
  final int biddingPlayer;
  final int biddingTeam;
  final int dealer;

  final int pointsTeamA;
  final int pointsTeamB;
  final int tricksWon;

  final DocumentReference reference;

  Hand(this.bid, this.biddingPlayer, this.biddingTeam, this.dealer,
      this.pointsTeamA, this.pointsTeamB, this.tricksWon,
      {this.reference});

  Hand.fromSnapshot(DocumentSnapshot snapshot)
      : bid = Bid.bidsMap[snapshot.data['bid']],
        biddingPlayer = snapshot.data['bidding_player'],
        biddingTeam = snapshot.data['bidding_team'],
        dealer = snapshot.data['dealer'],
        pointsTeamA = snapshot.data['points_teamA'],
        pointsTeamB = snapshot.data['points_teamB'],
        tricksWon = snapshot.data['tricks_won'],
        reference = snapshot.reference;

  @override
  String toString() =>
      "Hand<$pointsTeamA vs $pointsTeamB> with bid: ${bid.getSymbol()}";
}
