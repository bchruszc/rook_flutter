import 'package:rook_flutter/database/DbController.dart';
import 'package:rook_flutter/models/game.dart';

final String MatchTable = 'matches';
final String MatchColumnId = 'id';
final String MatchColumnGameId = 'Gameid';
final String MatchColumnBidder = 'bidder';
final String MatchColumnBid = 'bid';
final String MatchColumnPartnerOne = 'PartnerOne';
final String MatchColumnPartnerTwo = 'PartnerTwo';
final String MatchColumnMade = 'made';

class MatchMapper extends DTOMapper {
  int id;
  int gameId;
  int bidder;
  int bid;
  int partnerOne;
  int partnerTwo;
  int made;

  MatchMapper({Match match, this.gameId}) {
    if (match != null) {
      bidder = match.bidder.id;
      bid = match.bid.toInt();
      partnerOne = match.partners[0].id;
      if (match.partners.length > 1) {
        partnerOne = match.partners[1].id;
      }
      made = match.made.toInt();
    }
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      MatchColumnGameId: gameId,
      MatchColumnBidder: bidder,
      MatchColumnBid: bid,
      MatchColumnPartnerOne: partnerOne,
      MatchColumnPartnerTwo: partnerTwo,
      MatchColumnMade: made,
    };
    //it will auto generate otherwise
    if (id != null) {
      map[MatchColumnId] = id;
    }
    return map;
  }

  @override
  MatchMapper fromMap(Map<String, dynamic> map) {
    id = map[MatchColumnId];
    gameId = map[MatchColumnGameId];
    bidder = map[MatchColumnBidder];
    bid = map[MatchColumnBid];
    partnerOne = map[MatchColumnPartnerOne];
    partnerTwo = map[MatchColumnPartnerTwo];
    made = map[MatchColumnMade];

    return this;
  }

  @override
  String getTable() {
    return MatchTable;
  }

  @override
  MatchMapper createInstance() {
    return MatchMapper();
  }
}
