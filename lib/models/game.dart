import 'package:flutter/material.dart';
import 'package:rook_flutter/models/listitem.dart';

class GameInfo {
  List<Player> players = List();
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
  Player bidder;
  double bid = 100;
  int numberOfPlayers = 4;
  List<Player> partners = new List();
  double made = 100;
  bool submitted = false;

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

  List<DataCell> buildScoreLine(List<ScorePlayer> players) {
    List<DataCell> scoreLine = List();
    double howMuchMade = made - bid;
    double otherTeamPoints = 180 - made;
    bool madeIT = howMuchMade >= 0;

    for (ScorePlayer scorePlayer in players) {
      if (scorePlayer.player != null) {
        if (scorePlayer.player == bidder ||
            partners.contains(scorePlayer.player)) {
          if (madeIT) {
            scorePlayer.currentScore = scorePlayer.currentScore + made;
          } else {
            scorePlayer.currentScore = scorePlayer.currentScore - bid;
          }
        } else {
          scorePlayer.currentScore = scorePlayer.currentScore + otherTeamPoints;
        }
        scoreLine.add(DataCell(Wrap(children:[Text(scorePlayer.currentScore.toInt().toString())])));
      } else {
        scoreLine.add(DataCell(Wrap(children:[Text("(" +
            bid.toInt().toString() +
            ") " +
            bidder.getShortName() +
            " - " +
            partners.map((p) => p.getShortName()).join(' '))])));
      }
    }
    return scoreLine;
  }

  double lostValue() {
    return bid - made;
  }

  double madeValue() {
    return made;
  }
}

class ScorePlayer {
  Player player;
  double currentScore = 0; //temprary value used when building score

  ScorePlayer(this.player);

  bool operator ==(o) => o is ScorePlayer && o.player == player;

  int get hashcode => player.hashCode;
}

class Player {
  String name;

  Player(this.name);

  String getShortName() {
    return name.substring(0, 2); //fix me
  }
}
