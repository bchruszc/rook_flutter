import 'package:rook_flutter/models/listitem.dart';

class GameInfo {
  List<Player> players = List();
  List<Match> matches = List();
  Match currentMatch; //if there is a match in progress

  addPlayer(Player player) {
    players.add(player);
  }

  recordCurrentMatch() {
    matches.add(currentMatch);
    currentMatch=null;
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

  List<ListItem<Match>> getMatchListItems(){
    return matches.map((match) => ListItem(match)).toList();
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
