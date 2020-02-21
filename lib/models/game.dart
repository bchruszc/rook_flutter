import 'dart:collection';

import 'package:rook_flutter/models/listitem.dart';

class GameInfo {
  int databaseId;
  DateTime dateStarted = new DateTime.now();
  HashSet<Player> players = HashSet();
  List<Match> matches = List();

  addPlayer(Player player) {
    players.add(player);
  }

  Match getLatestMatch() {
    if (matches.length > 0) {
      return matches[matches.length - 1];
    } else {
      return null;
    }
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

  List<ListItem<Match>> getMatchListItems() {
    return matches.map((match) => ListItem(match)).toList();
  }

  List<ScorePlayer> buildScorePlayerList() {
    List<ScorePlayer> list =
        players.map((player) => ScorePlayer(player)).toList();
    list.add(ScorePlayer(null));
    return list;
  }

  bool isLatestMatchSetup() {
    Match match = getLatestMatch();
    if (match != null) {
      return match.isMatchSetup();
    }
    return false;
  }
}

class Match {
  int databaseId;
  Player bidder;
  double bid = 140;
  final int numberOfPlayers;
  List<Player> partners = new List();
  double made = 180;
  bool submitted = false;

  Match(this.numberOfPlayers);

  getNumOfPartners() {
    if (numberOfPlayers == 6) {
      return 2;
    } else {
      return 1;
    }
  }

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

  buildScoreLine(List<ScorePlayer> players) {
    double howMuchMade = made - bid;
    double otherTeamPoints = 180 - made;
    bool madeIT = howMuchMade >= 0;

    for (ScorePlayer scorePlayer in players) {
      if (scorePlayer.player != null) {
        if (scorePlayer.player == bidder ||
            partners.contains(scorePlayer.player)) {
          if (madeIT) {
            scorePlayer.score.add(
                scorePlayer.getLastScore() + made + getBonus(bidder, partners));
            if (scorePlayer.player == bidder) {
              scorePlayer.hasStar = true;
            }
          } else {
            scorePlayer.score.add(scorePlayer.getLastScore() - bid);
          }
        } else {
          scorePlayer.score.add(scorePlayer.getLastScore() + otherTeamPoints);
        }
      }
    }
  }

  int getBonus(Player bidder, List<Player> partners) {
    int bonus = 0;
    partners.forEach((p) => {
          if (p == bidder) {bonus = bonus + getBonusValue()}
        });
    return bonus;
  }

  int getBonusValue() {
    if (numberOfPlayers == 5) {
      return 30;
    } else {
      return 20;
    }
  }

  bool madeIt() {
    return down() <= 0;
  }

  int lostValue() {
    return 180 -
        made.toInt(); //problem here where sometimes the made is a point value ex 144.999999
  }

  int down(){
    return bid.toInt() -
        made.toInt(); //problem here where sometimes the made is a point value ex 144.999999
  }


  int madeValue() {
    return made.toInt();
  }
}

//Built on demand class to build score
class ScorePlayer {
  Player player;
  List<double> score = List();
  bool hasStar = false;

  ScorePlayer(this.player);

  bool operator ==(o) => o is ScorePlayer && o.player == player;

  int get hashcode => player.hashCode;

  double getLastScore() {
    if (score.length > 0) {
      return score[score.length - 1];
    } else {
      return 0;
    }
  }
}

class Player {
  String firstName;
  String lastName;
  int id;//api id
  String playerId; //don't think this is used

  Player(this.firstName, this.lastName, this.id, {this.playerId});

  Player.buildFromAPI(Map<String, dynamic> m) {
    firstName = m['first_name'];
    lastName = m['last_name'];
    id = m['id'] as int;
  }

  String getHeaderName() {
    if (getFullName().length > 5) {
      return getShortName();
    } else {
      return getFullName();
    }
  }

  String getFullName() {
    return firstName + " " + lastName;
  }

  String getShortName() {
    return firstName.substring(0, 1) + lastName.substring(0, 1);
  }

  bool operator ==(o) =>
      o is Player &&
      o.firstName == firstName &&
      o.lastName == lastName &&
      o.id == id;

  int get hashcode => firstName.hashCode + lastName.hashCode + id.hashCode;
}
