import 'package:flutter/material.dart';

class HomeRoute extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rook Score 2.0'),
      ),
      body: Column (
        children: <Widget>[CreateGameButton(),LoadGameButton()
        ],
      )
    );
  }
}

class CreateGameButton extends StatelessWidget{

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

class LoadGameButton extends StatelessWidget{
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
