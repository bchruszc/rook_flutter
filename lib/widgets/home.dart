import 'package:flutter/material.dart';
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
          Navigator.pushNamed(context, '\test', arguments: game);
        },
      ),
    );
  }
}

class ScoreView extends StatefulWidget {
  ScoreView({Key key}) : super(key: key);

  @override
  ScoreViewState createState() => ScoreViewState();
}

class ScoreViewState extends State<ScoreView> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text("Table Widget")),
        body: Column(
          children: <Widget>[
            buildHeader(),
            Expanded(
                child: ListView.builder(
              itemCount: 5,
              itemBuilder: buildItemTile,
            ))
          ],
        ),
      ),
    );
  }

  Widget buildHeader() {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 1.0, color: Color(0xFFFF000000)),
        ),
      ),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: new Text(
              "Martin",
            ),
          ),
          Expanded(
            child: new Text(
              "Brad H",
            ),
          ),
          Expanded(
            child: new Text(
              "Brad C",
            ),
          ),
          Expanded(
            child: new Text(
              "Jeremy",
            ),
          ),
          Expanded(
            child: new Text(
              "Jeremy",
            ),
          ),
          Expanded(
            child: new Text(
              "Jeremy",
            ),
          ),
          new SizedBox(
            width: 80.0,
            child: new Text(
              "",
            ),
          )
        ],
      ),
    );
  }

  Widget buildItemTile(BuildContext context, int index) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4),
      child: Container(
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(width: 1.0, color: Color(0xFFFF000000)),
          ),
        ),
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: new Text(
                "100",
              ),
            ),
            Expanded(
              child: new Text(
                "200",
              ),
            ),
            Expanded(
              child: new Text(
                "300",
              ),
            ),
            Expanded(
              child: new Text(
                "400",
              ),
            ),
            Expanded(
              child: new Text(
                "400",
              ),
            ),
            Expanded(
              child: new Text(
                "400",
              ),
            ),
            new SizedBox(
              width: 80.0,
              child: new Text(
                "(100) MV - RH BC",
              ),
            )
          ],
        ),
      ),
    );
  }
}
