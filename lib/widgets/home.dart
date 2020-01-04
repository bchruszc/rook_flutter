import 'package:flutter/material.dart';
import 'package:rook_flutter/models/game.dart';

class HomeRoute extends StatelessWidget {
  GameInfo currentGame;

  HomeRoute(this.currentGame);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Rook'),
        ),
        body: Column(
          children: <Widget>[CreateGame(currentGame), LoadGame()],
        ));
  }
}

class CreateGame extends StatelessWidget {
  GameInfo currentGame;

  CreateGame(this.currentGame);

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
    Navigator.pushNamed(context, '/NewGame');
  }
//
//  createGame(BuildContext context) async{
//    GameInfo result = await Navigator.pushNamed(context, '/NewGame');//add await and get new game data
//    if(result !=null){
//      currentGame = result;//this donsn't work
//      Navigator.pushNamed(context, '/LoadGame');
//    }
//  }

}

class LoadGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: RaisedButton(
        child: Text('Load Game'),
        onPressed: () {
          Navigator.pushNamed(context, '/LoadGame');
        },
      ),
    );
  }
}
