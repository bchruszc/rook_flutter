import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rook_flutter/models/game.dart';
import 'package:rook_flutter/widgets/home.dart';
import 'package:rook_flutter/widgets/newmatchcreen.dart';
import 'package:rook_flutter/widgets/playerselectionscreen.dart';
import 'package:rook_flutter/widgets/scorescreen.dart';
import 'package:screen/screen.dart';

List<Player> players = [
  Player('Martin', 'V', 1),
  Player('Brad', 'B', 2),
  Player('Brad', 'H', 3),
  Player('Ray', 'V', 4),
  Player('Jeremy', 'V', 5),
  Player('Iqbal', 'V', 6),
  Player('Allan', 'V', 7),
];

const String HomeRouteId = '/';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Screen.keepOn(true);
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .whenComplete(() {
    runApp(MaterialApp(
        title: 'Rook 2.0',
        onGenerateRoute: generateRoute,
        initialRoute: HomeRouteId,
        darkTheme: ThemeData.dark()));
  });
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
          builder: (context) => PlayerSelection(game: game));
    case NewMatchWidget.Id:
      return MaterialPageRoute(
          builder: (context) => NewMatchWidget(game: game));
    case Scoreboard.Id:
      return MaterialPageRoute(builder: (context) => Scoreboard(game: game));
    default:
      return MaterialPageRoute(builder: (context) => HomeRoute(game: game));
  }
}
