import 'package:flutter/material.dart';
import 'package:rook_flutter/models/game.dart';
import 'package:rook_flutter/models/listitem.dart';
import 'package:rook_flutter/widgets/home.dart';
import 'package:rook_flutter/widgets/newmatchcreen.dart';
import 'package:rook_flutter/widgets/playerselectionscreen.dart';
import 'package:rook_flutter/widgets/scorescreen.dart';

List<Player> players = [
  Player('Martin'),
  Player('Brad'),
  Player('Brad H'),
  Player('Ray'),
  Player('Jeremy'),
];

const String HomeRouteId = '/';

void main() {
  runApp(MaterialApp(
    title: 'Rook 2.0',
    onGenerateRoute: generateRoute,
    initialRoute: HomeRouteId,
  ));
}

Route<dynamic> generateRoute(RouteSettings settings) {
  var game;
  if (settings.arguments != null) {
    game = settings.arguments;
  }
  switch (settings.name) {
    case HomeRouteId:
      return MaterialPageRoute(builder: (context) => HomeRoute(game: game));
    case PlayerSelection.Id:
      return MaterialPageRoute(
          builder: (context) => PlayerSelection(
              game: game,
              items: players.map((player) => ListItem(player)).toList()));
    case NewMatchWidget.Id:
      return MaterialPageRoute(
          builder: (context) => NewMatchWidget(game: game));
    case Scoreboard.Id:
      return MaterialPageRoute(builder: (context) => Scoreboard(game: game));
    default:
      return MaterialPageRoute(builder: (context) => HomeRoute(game: game));
  }
}
