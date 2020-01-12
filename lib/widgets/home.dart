import 'package:flutter/material.dart';
import 'package:rook_flutter/models/game.dart';
import 'package:rook_flutter/widgets/newmatchcreen.dart';
import 'package:rook_flutter/widgets/playerselectionscreen.dart';
import 'package:rook_flutter/widgets/scorescreen.dart';

class HomeRoute extends StatelessWidget {
  final GameInfo game;

  HomeRoute({Key key, @required this.game}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rook Score 2.0'),
      ),
      body: Column(
        children: <Widget>[
          CreateGameButton(),
          LoadGameButton(game: game),
          ScoreViewButton(game: game)
        ],
      ),
    );
  }
}

class CreateGameButton extends StatelessWidget {
  CreateGameButton();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RaisedButton(
        child: Text('Create Game'),
        onPressed: () {
          createGame(context);
        },
      ),
    );
  }

  createGame(BuildContext context) {
    Navigator.pushNamed(context, PlayerSelection.Id, arguments: GameInfo());
  }
}

class LoadGameButton extends StatelessWidget {
  final GameInfo game;

  LoadGameButton({Key key, @required this.game}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RaisedButton(
        child: Text('Load Game'),
        onPressed: () {
          Navigator.pushNamed(context, NewMatchWidget.Id, arguments: game);
        },
      ),
    );
  }
}

class ScoreViewButton extends StatelessWidget {
  final GameInfo game;

  ScoreViewButton({Key key, @required this.game}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RaisedButton(
        child: Text('ScoreView'),
        onPressed: () {
          Navigator.pushNamed(context, Scoreboard.Id, arguments: game);
        },
      ),
    );
  }
}
