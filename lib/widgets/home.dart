import 'package:flutter/material.dart';

class HomeRoute extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rook'),
      ),
      body: Column (
        children: <Widget>[CreateGame(),LoadGame()
        ],
      )
    );
  }
}

class CreateGame extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return           Center(
      child: RaisedButton(
        child: Text('Create Game'),
        onPressed: () {
          Navigator.pushNamed(context, '/NewGame');
        },
      ),
    );
  }
}

class LoadGame extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return           Center(
      child: RaisedButton(
        child: Text('Load Game'),
        onPressed: () {
          Navigator.pushNamed(context, '/LoadGame');
        },
      ),
    );
  }
}
