import 'dart:math';

import 'bid.dart';
import 'scoring_prefs.dart';

class Scoring {
  static const int WINNING_SCORE = 500;
  static const int LOSING_SCORE = -500;

  static const int POINTS_PER_TRICK_WON_BY_LOSING_TEAM = 10;

  static const int BONUS = 250;

  ScoringPrefs scoringPrefs;

  static const Map<Suit, int> mSuitPoints = {
    Suit.SPADES: 40,
    Suit.CLUBS: 60,
    Suit.DIAMONDS: 80,
    Suit.HEARTS: 100,
    Suit.NOTRUMPS: 120,
    Suit.CLOSEDMISERE: 250,
    Suit.OPENMISERE: 500,
  };
  static const Map<Tricks, int> mTricksPoints = {
    Tricks.ZERO: 0,
    Tricks.SIX: 0,
    Tricks.SEVEN: 100,
    Tricks.EIGHT: 200,
    Tricks.NINE: 300,
    Tricks.TEN: 400,
  };

  Scoring(this.scoringPrefs);

  int calcScore(bool biddingTeam, Bid bid, int tricksWonByBiddingTeam) {
    return biddingTeam
        ? _calcBiddersScore(bid, tricksWonByBiddingTeam)
        : _calcNonBiddersScore(bid, tricksWonByBiddingTeam);
  }

  int _calcBiddersScore(Bid bid, int tricksWonByBiddingTeam) {
    int bidValue = mSuitPoints[bid.suit] + mTricksPoints[bid.tricks];
    if (bid.isWinningNumberOfTricks(tricksWonByBiddingTeam)) {
      if (scoringPrefs.tenTrickBonus &&
          tricksWonByBiddingTeam == Bid.TRICKS_PER_HAND) {
        return max(BONUS, bidValue);
      } else {
        return bidValue;
      }
    } else {
      return -bidValue;
    }
  }

  int _calcNonBiddersScore(Bid bid, int tricksWonByBiddingTeam) {
    if (_shouldNonBiddersReceivePoints(bid, tricksWonByBiddingTeam)) {
      if (bid.tricks == Tricks.ZERO) {
        // No points for non bidding team in misere bids.
        return 0;
      } else {
        return (Bid.TRICKS_PER_HAND - tricksWonByBiddingTeam) *
            POINTS_PER_TRICK_WON_BY_LOSING_TEAM;
      }
    } else {
      return 0;
    }
  }

  bool _shouldNonBiddersReceivePoints(Bid bid, int tricksWonByBiddingTeam) {
    return scoringPrefs.nonBiddingPoints == NonBiddingPointsEnum.always ||
        (scoringPrefs.nonBiddingPoints == NonBiddingPointsEnum.onlyWithLoss &&
            !bid.isWinningNumberOfTricks(tricksWonByBiddingTeam));
  }

  bool hasWon(bool biddingTeam, int score, int otherTeamScore) {
    if (score >= WINNING_SCORE && biddingTeam) {
      return true;
    }
    if (otherTeamScore <= LOSING_SCORE) {
      return true;
    }
    return false;
  }
}
