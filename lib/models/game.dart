class GameInfo {
  List<Player> players = List();
  List<FinishedMatch> matches = List();
  NewMatch currentMatch; //if there is a match in progress

  addPlayer(Player player) {
    players.add(player);
  }

  removePlayer(Player player) {
    players.remove(player);
  }

  getNumOfPlayers() {
    return players.length;
  }

  bool hasEnoughPlayer(){
    return players.length == 4 ||
        players.length == 5 ||
        players.length == 6;
  }
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
