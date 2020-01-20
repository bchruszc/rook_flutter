import 'package:flutter/material.dart';
import 'package:rook_flutter/models/game.dart';
import 'package:rook_flutter/models/listitem.dart';
import 'package:rook_flutter/widgets/newmatchcreen.dart';

class Scoreboard extends StatefulWidget {
  static const String Id = '/ViewScore';

  final GameInfo game;

  Scoreboard({Key key, @required this.game}) : super(key: key);

  @override
  ScoreboardState createState() => ScoreboardState();
}

class ScoreboardState extends State<Scoreboard> {
  List<ListItem<Match>> matches;
  List<Match> submittedMatches;
  List<ScorePlayer> _scorePlayers;

  ScoreboardState();

  @override
  void initState() {
    super.initState();
    matches = widget.game.getMatchListItems();
    matches.add(ListItem(Match(widget.game.players.length)));
    submittedMatches =
        widget.game.matches.where((match) => match.submitted).toList();
    _scorePlayers = widget.game.buildScorePlayerList();
    //this call will populate the scores for the player
    populateScoresForPlayer(_scorePlayers);
    _scorePlayers.sort((o1, o2) {
      //player is null just for the summary. Technically both o1 and o2 can't be null
      if (o1.player == null) {
        return 1;
      } else if (o2.player == null) {
        return -1;
      } else if (o1.player == null && o2.player == null) {
        return 0;
      } else {
        if (o1.hasStar && !o2.hasStar) {
          return -1;
        } else if (!o1.hasStar && o2.hasStar) {
          return 1;
        }
        return (o2.getLastScore() - o1.getLastScore()).toInt();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Score View"),
        actions: [DoneButton(game: widget.game)],
      ),
      floatingActionButton: FloatingActionButton.extended(
        elevation: 4.0,
        label: const Text('End Game'),
        onPressed: () {},
      ),
      body: Column(
        children: <Widget>[
          //buildHeader(_scorePlayers),
          buildHeader(_scorePlayers),
          Expanded(
              child: ListView.builder(
            itemCount: submittedMatches.length,
            itemBuilder: buildItemTile,
          ))
        ],
      ),
    );
  }

  populateScoresForPlayer(List<ScorePlayer> players) {
    List<Match> submittedMatches =
        widget.game.matches.where((match) => match.submitted).toList();
    if (submittedMatches.length >= 0) {
      submittedMatches.forEach((m) => m.buildScoreLine(players));
    }
  }

  Widget buildHeader(List<ScorePlayer> scorePlayers) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4),
      child: Container(
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(width: 1.0, color: Color(0xFFFF000000)),
          ),
        ),
        child: buildHeaders(scorePlayers),
      ),
    );
  }

  Widget buildItemTile(BuildContext context, int index) {
    Match match = submittedMatches[index];
    LinearGradient grad = LinearGradient(colors: [Colors.white, Colors.green]);
    if (!match.madeIt()) {
      grad = LinearGradient(colors: [Colors.white, Colors.redAccent]);
    }

    bool everyOneDealt = index % submittedMatches.length == 0;

    Color gradColor = match.madeIt() ? Colors.green : Colors.red;
    Color borderColor = getRoundColor(index);
    return Container(
      margin: EdgeInsets.symmetric(vertical: 3),
      child: Container(
        decoration: BoxDecoration(
          gradient: grad,
          border: Border(
            bottom: BorderSide(
                width: 1.0,
                color: everyOneDealt ? Colors.purpleAccent : Colors.black),
          ),
        ),
        child: buildMatchItem(index),
      ),
    );
  }

  Color getRoundColor(int index) {
    if (index % _scorePlayers.length == 0) {
      return Colors.green;
    } else {
      return Colors.black;
    }
  }

  Widget buildHeaders(List<ScorePlayer> scorePlayers) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: scorePlayers.map((sp) => getHeader(sp)).toList());
  }

  Widget buildMatchItem(int rowIndex) {
    return GestureDetector(
      onDoubleTap: () {
        widget.game.matches.remove(rowIndex);
        //TODO, this doesn't work
        AlertDialog(
          title: Text("Are you sure?"),
          content: Text("100% sure? I can't reverse this"),
          actions: [
            RaisedButton(child: Text("Cancel)")),
            RaisedButton(child: Text("Ok)"))
          ],
        );
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: _scorePlayers.map((sp) => buildScore(sp, rowIndex)).toList(),
      ),
    );
  }

  Widget buildScore(ScorePlayer sp, int rowIndex) {
    Match match = submittedMatches[rowIndex];

    if (sp.player == null) {
      return Container(
        margin: EdgeInsets.only(left: 5.0),
        child: SizedBox(
            width: 80.0, child: buildMatchTextBox(sp, match, rowIndex)),
      );
    } else {
      return Expanded(
          child: Container(
        height: 30,
        alignment: Alignment.center,
        child: buildMatchTextBox(sp, match, rowIndex),
      ));
    }
  }

  Widget getHeader(ScorePlayer player) {
    if (player == null || player.player == null) {
      return Container(
        margin: EdgeInsets.only(left: 5.0),
        child: SizedBox(width: 80.0, child: Text("")),
      );
    } else {
      return Expanded(child: buildStarHeader(player));
    }
  }

  Text buildMatchTextBox(ScorePlayer sp, Match match, int rowIndex) {
    return Text(
        sp.player == null
            ? buildMatchSummary(match)
            : sp.score[rowIndex].toInt().toString(),
        style: TextStyle(
          color: Colors.black,
          fontSize: 14,
        ));
  }

  String buildMatchSummary(Match match) {
    return "(" +
        match.bid.toInt().toString() +
        ") " +
        match.bidder.getShortName() +
        " - " +
        match.partners.map((p) => p.getShortName()).join(' ');
  }

  Widget buildStarHeader(ScorePlayer sp) {
    if (!sp.hasStar) {
      return Container(alignment: Alignment.center, child: buildHeaderText(sp));
    } else {
      return Container(
          alignment: Alignment.center,
          child: Stack(
            alignment: AlignmentDirectional.center,
            children: [
              IconTheme(
                data: IconThemeData(
                  color: Colors.lightBlue,
                  size: 30,
                ),
                child: Icon(Icons.star),
              ),
              buildHeaderText(sp),
            ],
          ));
    }
  }

  Text buildHeaderText(ScorePlayer sp) {
    return Text(sp.player.name,
        style: TextStyle(
          color: Colors.black,
          fontSize: 18,
        ));
  }
}

class DoneButton extends StatefulWidget {
  final GameInfo game;

  DoneButton({Key key, @required this.game}) : super(key: key);

  @override
  DoneButtonState createState() => DoneButtonState();
}

class DoneButtonState extends State<DoneButton> {
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: Text('New Match',
          style: TextStyle(color: Colors.white, fontSize: 20)),
      onPressed: () {
        Navigator.pushNamed(context, NewMatchWidget.Id, arguments: widget.game);
      },
    );
  }
}
