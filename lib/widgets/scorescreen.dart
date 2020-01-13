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

  ScoreboardState();

  @override
  void initState() {
    super.initState();
    matches = widget.game.getMatchListItems();
    matches.add(ListItem(Match()));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<ScorePlayer> scorePlayers = widget.game.buildScorePlayerList();
    return Scaffold(
        appBar: AppBar(
          title: Text("Score View"),
          actions: <Widget>[DoneButton(game: widget.game)],
        ),
        body: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: constraints.maxWidth),
              //this doing anything?
              child: DataTable(
                sortColumnIndex: null,
                horizontalMargin: 1.0,
                columnSpacing: getColumnSpacing(),
                //20,30,40?
                columns: scorePlayers
                    .map((scorePlayer) => DataColumn(
                        label: getHeader(scorePlayer), numeric: true))
                    .toList(),

                rows: buildRows(scorePlayers),
              ),
            ),
          ),
        ));
  }

  List<DataRow> buildRows(List<ScorePlayer> scorePlayers) {
    List<Match> submittedMatches =
        widget.game.matches.where((match) => match.submitted).toList();
    if (submittedMatches.length >= 0) {
      return submittedMatches
          .map(
            (match) => DataRow(cells: match.buildScoreLine(scorePlayers)),
          )
          .toList();
    } else {
      List<DataRow> rows = List();
      rows.add(DataRow(
          cells: scorePlayers
              .map((sp) => DataCell(Wrap(children: [
                    Text(sp.player == null
                        ? ""
                        : sp.currentScore.toInt().toString())
                  ])))
              .toList()));
      return rows;
    }
  }

  Widget getHeader(ScorePlayer player) {
    if (player == null || player.player == null) {
      return Wrap(
        children: [Text("")],
      );
    } else {
      return Wrap(
        children: [Text(player.player.name)],
      );
    }
  }

  double getColumnSpacing() {
    if (widget.game.players.length == 4) {
      return 30;
    } else if (widget.game.players.length == 5) {
      return 30;
    } else {
      return 20;
    }
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
