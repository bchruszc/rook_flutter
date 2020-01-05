import 'package:flutter/material.dart';
import 'package:frideos/frideos.dart';
import 'package:frideos_core/frideos_core.dart';
import 'package:rook_flutter/models/game.dart';
import 'package:rook_flutter/models/listitem.dart';
import 'package:rook_flutter/shared/inheritedprovider.dart';

class PlayerSelection extends StatefulWidget {
  final List<ListItem<Player>> items;
  final GameInfo game;

  PlayerSelection(this.items, this.game);

  @override
  PlayerSelectionState createState() => PlayerSelectionState(items, game);
}

class PlayerSelectionState extends State<PlayerSelection> {
  final List<ListItem<Player>> items;
  final GameInfo game;
  final StreamedValue<bool> disableButton = StreamedValue();

  PlayerSelectionState(this.items, this.game);

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
                  return DoneButton();
                }),
          )
        ],
      ),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: buildItemTile,
      ),
    );
  }

  Widget buildItemTile(BuildContext context, int index) {
    return GestureDetector(
      onTap: () {
        if (items.any((item) => item.isSelected)) {
          setState(() {
            items[index].isSelected = !items[index].isSelected;
          });
          if (items[index].isSelected) {
            game.addPlayer(items[index].data);
          } else {
            game.removePlayer(items[index].data);
          }
          updateButtonState(disableButton);
        }
      },
      onLongPress: () {
        setState(() {
          items[index].isSelected = true;
        });
        game.addPlayer(items[index].data);
        updateButtonState(disableButton);
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4),
        color: items[index].isSelected ? Colors.red[100] : Colors.white,
        child: ListTile(
          title: Text(items[index].data.name),
        ),
      ),
    );
  }

  updateButtonState(StreamedValue<bool> disableButton) {
    disableButton.value = !game.hasEnoughPlayer();
    disableButton.refresh();
  }
}

class DoneButton extends StatefulWidget {
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
        disableButton.value ? null : Navigator.pushNamed(context, '/LoadGame');
      },
    );
  }
}
