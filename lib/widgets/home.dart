import 'package:flutter/material.dart';
import 'package:rook_flutter/database/DbController.dart';
import 'package:rook_flutter/database/gamemapper.dart';
import 'package:rook_flutter/main.dart';
import 'package:rook_flutter/models/game.dart';
import 'package:rook_flutter/widgets/newmatchcreen.dart';
import 'package:rook_flutter/widgets/playerselectionscreen.dart';

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
          TestButton(game: game)
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

class TestButton extends StatelessWidget {
  final GameInfo game;

  TestButton({Key key, @required this.game}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RaisedButton(
        child: Text('Test DB'),
        onPressed: () {
          dbstuff();
        },
      ),
    );
  }

  dbstuff() {
    DatabaseControl.instance.loadAll(GameMapper()).then((value) {
      print(value.length);
    });

    GameInfo info = new GameInfo();
    info.addPlayer(players[0]);
    info.addPlayer(players[2]);
    info.addPlayer(players[3]);
    info.addPlayer(players[4]);

    GameMapper mapper = GameMapper(game:info);

    DatabaseControl.instance.insert(mapper);
    DatabaseControl.instance.loadAll(GameMapper()).then((value) {
      print(value.length);
      print(value[0].player2);
    });

  }
}
