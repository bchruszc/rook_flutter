import 'package:flutter/material.dart';
import 'package:rook_flutter/models/game.dart';
import 'package:rook_flutter/models/listitem.dart';
import 'package:rook_flutter/widgets/home.dart';
import 'package:rook_flutter/widgets/newgamescreen.dart';
import 'package:rook_flutter/widgets/newmatchcreen.dart';

List<Player> players = [
  Player('Martin'),
  Player('Brad'),
  Player('Brad H'),
  Player('Ray'),
  Player('Jeremy'),
];

void main() {
  NewMatch currentMatch;
  GameInfo currentGame;

  runApp(MaterialApp(
    initialRoute: '/',
    routes: {
      '/': (context) => HomeRoute(currentGame),
      '/NewGame': (context) {
        currentGame = GameInfo();
        return PlayerSelection(
            players.map((player) => ListItem(player)).toList(), currentGame);
      },
      '/LoadGame': (context) {
        currentGame = GameInfo();
        currentGame.players = players;
        return NewMatchWidget(currentGame);
      } //todo for games not matches
    },
  ));
}
