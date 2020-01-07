class GameInfo {
  List<Player> players = List();
  List<Match> matches = List();
  Match currentMatch; //if there is a match in progress

  addPlayer(Player player) {
    players.add(player);
  }

  removePlayer(Player player) {
    players.remove(player);
  }

  getNumOfPlayers() {
    return players.length;
  }

  bool hasEnoughPlayer() {
    return players.length == 4 || players.length == 5 || players.length == 6;
  }
}

class Match {
  Player bidder;
  double bid = 100;
  int numberOfPlayers = 4;
  List<Player> partners = new List();
  double made = 100;

  bool isMatchSetup() {
    if (bidder != null && bid != null) {
      if (((numberOfPlayers == 4 || numberOfPlayers == 5) &&
              partners.length == 1) ||
          (numberOfPlayers == 6 && partners.length == 2)) {
        return true;
      }
    }
    return false;
  }

  double lostValue(){
    return bid-made;
  }
  double madeValue(){
    return made;
  }
}

class Player {
  String name;

  Player(this.name);
}
