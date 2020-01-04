class GameInfo {
  List<Player> players = List();
  List<FinishedMatch> matches = List();
  NewMatch currentMatch; //if there is a match in progress
}

class NewMatch {
  Player bidder;
  double bid = 100;
  List<Player> partners = new List();
}

class FinishedMatch extends NewMatch {
  double made = 0;
}

class Player {
  String name;

  Player(this.name);
}
