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
    return Scaffold(
        appBar: AppBar(
          title: Text("Score View"),
          actions: <Widget>[DoneButton(game: widget.game)],
        ),
        body: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minWidth: constraints.maxWidth),
              //this doing anything?
              child: DataTable(
                  sortColumnIndex: null,
                  horizontalMargin: 1.0,
                  columnSpacing: 20,
                  //20,30,40?
                  columns: [
                    DataColumn(label: Text('MV'), numeric: true),
                    DataColumn(label: Text('BC'), numeric: true),
                    DataColumn(label: Text('BH'), numeric: true),
                    DataColumn(label: Text('MV'), numeric: true),
                    DataColumn(label: Text('BH'), numeric: true),
                    DataColumn(label: Text('MV'), numeric: true),
                    DataColumn(label: Text('')),
                  ],
                  rows: [
                    DataRow(selected: true, cells: [
                      DataCell(Text('1000')),
                      DataCell(Text('1000')),
                      DataCell(Text('1000')),
                      DataCell(Text('1000')),
                      DataCell(Text('1000')),
                      DataCell(Text('1000')),
                      DataCell(getBidInfo()),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('1000')),
                      DataCell(Text('1000')),
                      DataCell(Text('1000')),
                      DataCell(Text('1000')),
                      DataCell(Text('1000')),
                      DataCell(Text('1000')),
                      DataCell(getBidInfo()),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('1000')),
                      DataCell(Text('1000')),
                      DataCell(Text('1000')),
                      DataCell(Text('1000')),
                      DataCell(Text('1000')),
                      DataCell(Text('1000')),
                      DataCell(getBidInfo()),
                    ]),
                  ]),
            ),
          ),
        ));
  }

  Widget buildItemTile(BuildContext context, int index) {
    if (index == 0) {
      return Row(children: [
        Center(child: Text("MV")),
        Spacer(),
        Text("BC"),
        Spacer(),
        Text("Ray"),
        Spacer(),
        Center(child: Text("Jeremy")),
        Spacer(),
        Text("Allan"),
        Spacer(),
        Text("BH"),
        Spacer(),
        Text(" "),
      ]);
    } else {
      return GestureDetector(
        onDoubleTap: () {
//        setState(() {
//          matches.removeAt(index);
//        });
        },
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 4),
          color: Colors.white,
          child: Row(children: [
            Text("1111"),
            Spacer(),
            Text("2222"),
            Spacer(),
            Text("3333"),
            Spacer(),
            Text("4444"),
            Spacer(),
            Text("5555"),
            Spacer(),
            Text("6666"),
            Spacer(),
            getBidInfo()
          ]),
        ),
      );
    }
  }

  Widget getBidInfo() {
    return Text("(123) MV - BC BH");
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
