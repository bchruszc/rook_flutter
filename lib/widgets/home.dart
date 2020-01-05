import 'package:flutter/material.dart';
import 'package:rook_flutter/models/game.dart';

class HomeRoute extends StatelessWidget {
  final GameInfo currentGame;

  HomeRoute(this.currentGame);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Rook Score 2.0'),
        ),
        body: Column(
          children: <Widget>[CreateGameButton(currentGame), LoadGameButton()],
        ));
  }
}

class CreateGameButton extends StatelessWidget {
  final GameInfo currentGame;

  CreateGameButton(this.currentGame);

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

class LoadGameButton extends StatelessWidget {
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
