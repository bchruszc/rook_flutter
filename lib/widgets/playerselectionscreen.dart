import 'package:flutter/material.dart';
import 'package:frideos/frideos.dart';
import 'package:frideos_core/frideos_core.dart';
import 'package:rook_flutter/httpapi/httpcontroller.dart';
import 'package:rook_flutter/models/game.dart';
import 'package:rook_flutter/models/listitem.dart';
import 'package:rook_flutter/shared/inheritedprovider.dart';
import 'package:rook_flutter/widgets/newmatchcreen.dart';

//Player selection entry
class PlayerSelection extends StatefulWidget {
  static const String Id = '/PlayerSelect';
  final GameInfo game;

  PlayerSelection({Key key, @required this.game}) : super(key: key);

  @override
  PlayerSelectionState createState() => PlayerSelectionState();
}

class PlayerSelectionState extends State<PlayerSelection> {
  final StreamedValue<bool> disableButton = StreamedValue();
  Future<GetListResponse> playerGet;

  List<ListItem<Player>> cachedItemList;

  @override
  void initState() {
    super.initState();
    disableButton.value = true;
    playerGet = APIRequest().getAPI(PlayerList);
  }

  @override
  void dispose() {
    super.dispose();
    disableButton.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Player Selection"),
        actions: <Widget>[
          InheritedProvider<bool>(
            inheritedData: disableButton,
            child: StreamedWidget(
              stream: disableButton.outStream,
              builder: (context, snapshot) {
                return DoneButton(widget.game);
              },
            ),
          )
        ],
      ),
      body: FutureBuilder<GetListResponse>(
        future: playerGet,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (cachedItemList == null) {
              List<Player> players = snapshot.data.jsons
                  .map((m) => Player.buildFromAPI(m))
                  .toList();
              cachedItemList =
                  players.map((player) => ListItem(player)).toList();
            }
            return ListView.builder(
              itemCount: cachedItemList.length,
              itemBuilder: buildItemTile,
            );
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }

          // By default, show a loading spinner.
          return CircularProgressIndicator();
        },
      ),
    );
  }

  Widget buildItemTile(BuildContext context, int index) {
    return GestureDetector(
      onTap: () {
        //if anything is selected
        if (cachedItemList.any((item) => item.isSelected)) {
          setState(() {
            cachedItemList[index].isSelected =
                !cachedItemList[index].isSelected;
          });
          if (cachedItemList[index].isSelected) {
            widget.game.addPlayer(cachedItemList[index].data);
          } else {
            widget.game.removePlayer(cachedItemList[index].data);
          }
          updateButtonState(disableButton);
        }
      },
      onLongPress: () {
        setState(() {
          cachedItemList[index].isSelected = true;
        });
        widget.game.addPlayer(cachedItemList[index].data);
        updateButtonState(disableButton);
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4),
        color:
            cachedItemList[index].isSelected ? Colors.red[100] : Colors.white,
        child: ListTile(
          title: Text(cachedItemList[index].data.getFullName()),
        ),
      ),
    );
  }

  updateButtonState(StreamedValue<bool> disableButton) {
    disableButton.value = !widget.game.hasEnoughPlayer();
    disableButton.refresh();
  }
}

class DoneButton extends StatefulWidget {
  final GameInfo game;

  DoneButton(this.game);

  @override
  DoneButtonState createState() => DoneButtonState();
}

class DoneButtonState extends State<DoneButton> {
  @override
  Widget build(BuildContext context) {
    final StreamedValue<bool> disableButton =
        InheritedProvider.of<bool>(context).inheritedData;
    return FlatButton(
      child: Text('Done',
          style: TextStyle(
              color: disableButton.value ? Colors.grey : Colors.white,
              fontSize: 20)),
      onPressed: () {
        disableButton.value
            ? null
            : Navigator.pushNamed(context, NewMatchWidget.Id,
                arguments: widget.game);
      },
    );
  }
}
