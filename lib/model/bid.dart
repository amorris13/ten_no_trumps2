class Bid {
  static const Bid SIX_SPADES = Bid(Tricks.SIX, Suit.SPADES);
  static const Bid SIX_CLUBS = Bid(Tricks.SIX, Suit.CLUBS);
  static const Bid SIX_DIAMONDS = Bid(Tricks.SIX, Suit.DIAMONDS);
  static const Bid SIX_HEARTS = Bid(Tricks.SIX, Suit.HEARTS);
  static const Bid SIX_NOTRUMPS = Bid(Tricks.SIX, Suit.NOTRUMPS);
  static const Bid SEVEN_SPADES = Bid(Tricks.SEVEN, Suit.SPADES);
  static const Bid SEVEN_CLUBS = Bid(Tricks.SEVEN, Suit.CLUBS);
  static const Bid SEVEN_DIAMONDS = Bid(Tricks.SEVEN, Suit.DIAMONDS);
  static const Bid SEVEN_HEARTS = Bid(Tricks.SEVEN, Suit.HEARTS);
  static const Bid SEVEN_NOTRUMPS = Bid(Tricks.SEVEN, Suit.NOTRUMPS);
  static const Bid EIGHT_SPADES = Bid(Tricks.EIGHT, Suit.SPADES);
  static const Bid EIGHT_CLUBS = Bid(Tricks.EIGHT, Suit.CLUBS);
  static const Bid EIGHT_DIAMONDS = Bid(Tricks.EIGHT, Suit.DIAMONDS);
  static const Bid EIGHT_HEARTS = Bid(Tricks.EIGHT, Suit.HEARTS);
  static const Bid EIGHT_NOTRUMPS = Bid(Tricks.EIGHT, Suit.NOTRUMPS);
  static const Bid NINE_SPADES = Bid(Tricks.NINE, Suit.SPADES);
  static const Bid NINE_CLUBS = Bid(Tricks.NINE, Suit.CLUBS);
  static const Bid NINE_DIAMONDS = Bid(Tricks.NINE, Suit.DIAMONDS);
  static const Bid NINE_HEARTS = Bid(Tricks.NINE, Suit.HEARTS);
  static const Bid NINE_NOTRUMPS = Bid(Tricks.NINE, Suit.NOTRUMPS);
  static const Bid TEN_SPADES = Bid(Tricks.TEN, Suit.SPADES);
  static const Bid TEN_CLUBS = Bid(Tricks.TEN, Suit.CLUBS);
  static const Bid TEN_DIAMONDS = Bid(Tricks.TEN, Suit.DIAMONDS);
  static const Bid TEN_HEARTS = Bid(Tricks.TEN, Suit.HEARTS);
  static const Bid TEN_NOTRUMPS = Bid(Tricks.TEN, Suit.NOTRUMPS);
  static const Bid CLOSEDMISERE = Bid(Tricks.ZERO, Suit.CLOSEDMISERE);
  static const Bid OPENMISERE = Bid(Tricks.ZERO, Suit.OPENMISERE);

  static const int TRICKS_PER_HAND = 10;

  static const List<Bid> BIDS = const [
    SIX_SPADES,
    SIX_CLUBS,
    SIX_DIAMONDS,
    SIX_HEARTS,
    SIX_NOTRUMPS,
    SEVEN_SPADES,
    SEVEN_CLUBS,
    SEVEN_DIAMONDS,
    SEVEN_HEARTS,
    SEVEN_NOTRUMPS,
    EIGHT_SPADES,
    EIGHT_CLUBS,
    EIGHT_DIAMONDS,
    EIGHT_HEARTS,
    EIGHT_NOTRUMPS,
    NINE_SPADES,
    NINE_CLUBS,
    NINE_DIAMONDS,
    NINE_HEARTS,
    NINE_NOTRUMPS,
    TEN_SPADES,
    TEN_CLUBS,
    TEN_DIAMONDS,
    TEN_HEARTS,
    TEN_NOTRUMPS,
    CLOSEDMISERE,
    OPENMISERE,
  ];

  static final Map<String, Bid> bidsMap = Map.fromIterable(BIDS,
      key: (item) => item.toFullString(), value: (item) => item);

  final Tricks tricks;
  final Suit suit;

  const Bid(this.tricks, this.suit);

  String getSymbol() {
    return tricks.getSymbol() + suit.symbol;
  }

  bool isWinningNumberOfTricks(int tricksWonByBiddingTeam) {
    if (tricks == Tricks.ZERO) {
      return tricksWonByBiddingTeam == 0;
    } else {
      return tricksWonByBiddingTeam >= tricks.number;
    }
  }

  static Bid getBid(Tricks tricks, Suit suit) {
    // TODO: calculate correctly.
    return SIX_CLUBS;
  }

  String toFullString() {
    return (tricks == Tricks.ZERO)
        ? suit.toString()
        : tricks.toString() + " " + suit.toString();
  }
}

class Tricks {
  static const Tricks ZERO = Tricks(0, "");
  static const Tricks SIX = Tricks(6, "Six");
  static const Tricks SEVEN = Tricks(7, "Seven");
  static const Tricks EIGHT = Tricks(8, "Eight");
  static const Tricks NINE = Tricks(9, "Nine");
  static const Tricks TEN = Tricks(10, "Ten");

  final int number;
  final String name;

  const Tricks(this.number, this.name);

  String getSymbol() {
    return number == 0 ? "" : number.toString();
  }

  @override
  String toString() => name;
}

class Suit {
  static const Suit SPADES = Suit("Spades", "\u2660", Color.BLACK);
  static const Suit CLUBS = Suit("Clubs", "\u2663", Color.BLACK);
  static const Suit DIAMONDS = Suit("Diamonds", "\u2666", Color.RED);
  static const Suit HEARTS = Suit("Hearts", "\u2665", Color.RED);
  static const Suit NOTRUMPS = Suit("No Trumps", "NT", Color.BLACK);
  static const Suit CLOSEDMISERE = Suit("Closed Misere", "CM", Color.BLACK);
  static const Suit OPENMISERE = Suit("Open Misere", "OM", Color.BLACK);

  final String name;
  final String symbol;
  final Color color;

  const Suit(this.name, this.symbol, this.color);

  @override
  String toString() => name;
}

enum Color { BLACK, RED }
