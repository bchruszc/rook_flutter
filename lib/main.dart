import 'package:flutter/material.dart';
import 'package:rook_flutter/widgets/home.dart';
import 'package:rook_flutter/models/game.dart';
import 'package:rook_flutter/widgets/newmatchcreen.dart';

void main() {
  NewMatch currentMatch;

  runApp(MaterialApp(
     initialRoute: '/',
    routes: {
      '/': (context) => HomeRoute(),
      '/NewGame': (context){
        currentMatch = NewMatch();
        return ExpansionStateWidget(currentMatch); //todo for games not matches
      },
      '/LoadGame': (context) => ExpansionStateWidget(currentMatch),//todo for games not matches
    },
  ));
}