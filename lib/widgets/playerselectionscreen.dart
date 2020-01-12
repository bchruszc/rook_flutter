import 'package:flutter/material.dart';
import 'package:frideos/frideos.dart';
import 'package:frideos_core/frideos_core.dart';
import 'package:rook_flutter/models/game.dart';
import 'package:rook_flutter/models/listitem.dart';
import 'package:rook_flutter/shared/inheritedprovider.dart';
import 'package:rook_flutter/widgets/newmatchcreen.dart';

//Player selection entry
class PlayerSelection extends StatefulWidget {
  static const String Id = '/PlayerSelect';
  final List<ListItem<Player>> items;
  final GameInfo game;

  PlayerSelection({Key key, @required this.game, @required this.items})
      : super(key: key);

  @override
  PlayerSelectionState createState() => PlayerSelectionState();
}

class PlayerSelectionState extends State<PlayerSelection> {
  final StreamedValue<bool> disableButton = StreamedValue();

  @override
  void initState() {
    super.initState();
    disableButton.value = true;
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
      body: ListView.builder(
        itemCount: widget.items.length,
        itemBuilder: buildItemTile,
      ),
    );
  }

  Widget buildItemTile(BuildContext context, int index) {
    return GestureDetector(
      onTap: () {
        if (widget.items.any((item) => item.isSelected)) {
          setState(() {
            widget.items[index].isSelected = !widget.items[index].isSelected;
          });
          if (widget.items[index].isSelected) {
            widget.game.addPlayer(widget.items[index].data);
          } else {
            widget.game.removePlayer(widget.items[index].data);
          }
          updateButtonState(disableButton);
        }
      },
      onLongPress: () {
        setState(() {
          widget.items[index].isSelected = true;
        });
        widget.game.addPlayer(widget.items[index].data);
        updateButtonState(disableButton);
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4),
        color: widget.items[index].isSelected ? Colors.red[100] : Colors.white,
        child: ListTile(
          title: Text(widget.items[index].data.name),
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
