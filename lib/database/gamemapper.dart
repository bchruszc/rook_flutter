import 'package:rook_flutter/database/DbController.dart';
import 'package:rook_flutter/models/game.dart';

final String GameTable = 'game';
final String GameColumnId = 'id';
final String GameColumnCreatedDate = 'CreatedDate';
final String GameColumnPlayerOne = 'PlayerOne';
final String GameColumnPlayerTwo = 'PlayerTwo';
final String GameColumnPlayerThree = 'PlayerThree';
final String GameColumnPlayerFour = 'PlayerFour';
final String GameColumnPlayerFive = 'PlayerFive';
final String GameColumnPlayerSix = 'PlayerSix';

class GameMapper extends DTOMapper {
  int id;
  DateTime createdDate;
  int player1;
  int player2;
  int player3;
  int player4;
  int player5;
  int player6;

  GameMapper({GameInfo game}) {
    if (game != null) {
      createdDate = game.dateStarted;
      int numberOfPlayer = game.players.length;
      player1 = game.players.elementAt(0).id;
      player2 = game.players.elementAt(1).id;
      player3 = game.players.elementAt(2).id;
      player4 = game.players.elementAt(3).id;
      if (numberOfPlayer > 4) {
        player5 = game.players.elementAt(4).id;
      }
      if (numberOfPlayer > 5) {
        player6 = game.players.elementAt(5).id;
      }
    }
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
//      GameColumnCreatedDate: createdDate,
      GameColumnPlayerOne: player1,
      GameColumnPlayerTwo: player2,
      GameColumnPlayerThree: player3,
      GameColumnPlayerFour: player4,
      GameColumnPlayerFive: player5,
      GameColumnPlayerSix: player6,
    };
    //it will auto generate otherwise
    if (id != null) {
      map[GameColumnId] = id;
    }
    return map;
  }

  @override
  DTOMapper fromMap(Map<String, dynamic> map) {
    id = map[GameColumnId];
//    createdDate = map[GameColumnCreatedDate];
    player1 = map[GameColumnPlayerOne];
    player2 = map[GameColumnPlayerTwo];
    player3 = map[GameColumnPlayerThree];
    player4 = map[GameColumnPlayerFour];
    player5 = map[GameColumnPlayerFive];
    player6 = map[GameColumnPlayerSix];

    return this;
  }

  @override
  String getTable() {
    return GameTable;
  }

  @override
  DTOMapper createInstance() {
    return GameMapper();
  }
}
