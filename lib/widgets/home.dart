import 'package:flutter/material.dart';
import 'package:rook_flutter/database/DbController.dart';
import 'package:rook_flutter/database/gamemapper.dart';
import 'package:rook_flutter/database/matchmapper.dart';
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
          IntrinsicWidth(
              child: Row(children: [
            Spacer(),
            DeleteAllButton(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
            ),
            CreateGameButton(),
            Spacer(),
          ])),
          //    LoadGameButton(game: game),
          Expanded(child: ListGames()),
          //   TestButton(game: game)
        ],
      ),
    );
  }
}

class ListGames extends StatefulWidget {
  @override
  ListGamesState createState() => ListGamesState();
}

class ListGamesState extends State<ListGames> {
  Future<List<GameAndMatchMappers>> games;

  @override
  void initState() {
    super.initState();
    games = DatabaseControl.instance.loadAllGames();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: FutureBuilder(
      future: games,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (context, index) {
              GameAndMatchMappers value = snapshot.data[index];
              var id = value.gameMapper.id;
              int numOfPlayers = value.getNumberOfPlayers();
              int numOfMatches =
                  value.matchMappers != null ? value.matchMappers.length : 0;
              return GestureDetector(
                behavior: HitTestBehavior.translucent,
                child: Container(
                  child: Padding(
                    padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
                    child: Container(
                      child: Center(
                        child: Text(
                          'Game:$id Players:$numOfPlayers Matches:$numOfMatches',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        } else {
          return CircularProgressIndicator();
        }
      },
    ));
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

class DeleteAllButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: RaisedButton(
        child: Text('Delete All'),
        onPressed: () {
          deleteAll(context);
        },
      ),
    );
  }

  deleteAll(BuildContext context) {
    DatabaseControl.instance.deleteAll(MatchMapper());
    DatabaseControl.instance.deleteAll(GameMapper());
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

    GameMapper mapper = GameMapper(game: info);

    DatabaseControl.instance.insert(mapper);
    DatabaseControl.instance.loadAll(GameMapper()).then((value) {
      print(value.length);
      print(value[0].player2);
    });
  }
}
