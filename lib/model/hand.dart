import 'bid.dart';

class Hand {
  final Bid bid;
  final int biddingPlayer;
  final int biddingTeam;
  final int dealer;

  final int pointsTeamA;
  final int pointsTeamB;
  final int tricksWon;

  Hand(this.bid, this.biddingPlayer, this.biddingTeam, this.dealer,
      this.pointsTeamA, this.pointsTeamB, this.tricksWon);

  Hand.fromMap(Map map)
      : bid = Bid.bidsMap[map['bid']],
        biddingPlayer = map['bidding_player'],
        biddingTeam = map['bidding_team'],
        dealer = map['dealer'],
        pointsTeamA = map['points_teamA'],
        pointsTeamB = map['points_teamB'],
        tricksWon = map['tricks_won'];

  @override
  String toString() =>
      "Hand<$pointsTeamA vs $pointsTeamB> with bid: ${bid.getSymbol()}";
}
