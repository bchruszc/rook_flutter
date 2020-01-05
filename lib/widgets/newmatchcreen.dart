import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rook_flutter/models/game.dart';

class PartnerSelection extends NewGameExpandableItem {
  final List<Player> players;

  PartnerSelection(NewMatch newMatch, this.players, {bool isExpanded = false})
      : super(newMatch, isExpanded);

  @override
  ExpansionPanel create(
      State expandedState, List<NewGameExpandableItem> items) {
    return ExpansionPanel(
      headerBuilder: (BuildContext context, bool isExpanded) {
        if (newMatch.partners.length == 0) {
          return Text('No Partners');
        } else {
          return Wrap(
              spacing: 2.0,
              direction: Axis.horizontal,
              children: newMatch.partners.map<FlatButton>((Player player) {
                return FlatButton(
                  onPressed: () {
                    expandedState.setState(() {
                      newMatch.partners.remove(player);
                    });
                  },
                  child: Text(player.name, style: TextStyle(fontSize: 16)),
                );
              }).toList());
        }
      },
      body: Container(
        child: Wrap(
            spacing: 2.0,
            direction: Axis.horizontal,
            children: players.map<RaisedButton>((Player player) {
              return RaisedButton(
                onPressed: () {
                  expandedState.setState(() {
                    newMatch.partners.add(player);
                  });
                },
                child: Text(player.name, style: TextStyle(fontSize: 20)),
              );
            }).toList()),
      ),
      isExpanded: isExpanded,
    );
  }
}

class CallerSelection extends NewGameExpandableItem {
  final List<Player> players;

  CallerSelection(NewMatch newMatch, this.players, {bool isExpanded = false})
      : super(newMatch, isExpanded);

  @override
  ExpansionPanel create(
      State expandedState, List<NewGameExpandableItem> items) {
    return ExpansionPanel(
      headerBuilder: (BuildContext context, bool isExpanded) {
        return ListTile(
          title: Text(newMatch.bidder != null
              ? "Bidder: " + newMatch.bidder.name
              : 'Select Caller'),
        );
      },
      body: Container(
        child: Wrap(
            direction: Axis.horizontal,
            children: players.map<RaisedButton>((Player player) {
              return RaisedButton(
                onPressed: () {
                  expandedState.setState(() {
                    newMatch.bidder == player
                        ? newMatch.bidder = null
                        : newMatch.bidder = player;
                    isExpanded = false; //we made a selection unexpand section
                  });
                },
                child: Text(player.name, style: TextStyle(fontSize: 20)),
              );
            }).toList()),
      ),
      isExpanded: isExpanded,
    );
  }
}

class SliderItem extends NewGameExpandableItem {
  SliderItem(NewMatch newMatch, {bool isExpanded = false})
      : super(newMatch, isExpanded);

  @override
  ExpansionPanel create(State expandState, List<NewGameExpandableItem> items) {
    return ExpansionPanel(
      headerBuilder: (BuildContext context, bool isExpanded) {
        return ListTile(
          title: Text("Current Bid: " + newMatch.bid.toString()),
        );
      },
      body: SliderWidget(newMatch, expandState),
      isExpanded: isExpanded,
    );
  }
}

class SliderWidget extends StatefulWidget {
  final NewMatch newMatch;
  final State expandState;

  SliderWidget(this.newMatch, this.expandState);

  @override
  SliderState createState() => SliderState(newMatch, expandState);
}

class SliderState extends State<SliderWidget> {
  NewMatch newMatch;
  State expandState;

  SliderState(this.newMatch, this.expandState);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Slider(
        value: newMatch.bid,
        min: 100,
        max: 180,
        divisions: 16,
        label: 'Bid',
        onChanged: (newrating) {
          setState(() {
            newMatch.bid = newrating;
          });
          expandState.setState(() {
            newMatch.bid = newrating;
          });
        },
      ),
    );
  }
}

// For testing
class BasicItem extends NewGameExpandableItem {
  BasicItem(NewMatch newMatch, {bool isExpanded = false})
      : super(newMatch, isExpanded);

  @override
  ExpansionPanel create(State state, List<NewGameExpandableItem> items) {
    return ExpansionPanel(
      headerBuilder: (BuildContext context, bool isExpanded) {
        return ListTile(
          title: Text('Header'),
        );
      },
      body: ListTile(
          title: Text('Expanded'),
          subtitle: Text('To delete this panel, tap the trash can icon'),
          trailing: Icon(Icons.delete),
          //remove myself from items
          onTap: () {
            state.setState(() {
              items.removeWhere((currentItem) => this == currentItem);
            });
          }),
      isExpanded: isExpanded,
    );
  }
}

// stores ExpansionPanel state information
abstract class NewGameExpandableItem {
  final NewMatch newMatch;
  bool isExpanded = false;
  bool isLocked;

  NewGameExpandableItem(this.newMatch, this.isExpanded,
      {this.isLocked = false});

  ExpansionPanel create(State state, List<NewGameExpandableItem> items);
}

//Entry
class NewMatchWidget extends StatelessWidget {
  final GameInfo game;

  NewMatchWidget(this.game);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("New Match"),
        ),
        body: ExpansionStateWidget(game));
  }
}

class ExpansionStateWidget extends StatefulWidget {
  final GameInfo game;

  ExpansionStateWidget(this.game, {Key key}) : super(key: key);

  @override
  ExpansionControls createState() => ExpansionControls(NewMatch(), game);
}

class ExpansionControls extends State<ExpansionStateWidget> {
  NewMatch newMatch;
  GameInfo game;
  List<NewGameExpandableItem> newItems;

  ExpansionControls(NewMatch newMatch, GameInfo game) {
    this.newMatch = newMatch;
    this.game = game;
    newItems = [
      CallerSelection(newMatch, game.players),
      SliderItem(newMatch),
      PartnerSelection(newMatch, game.players),
      BasicItem(newMatch)
    ];
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: buildPanel(),
      ),
    );
  }

  Widget buildPanel() {
    return SafeArea(
      child: ExpansionPanelList(
        expansionCallback: (int index, bool isExpanded) {
          setState(() {
            newItems[index].isExpanded = !isExpanded;
          });
        },
        children: newItems.map<ExpansionPanel>((NewGameExpandableItem item) {
          return item.create(this, newItems);
        }).toList(),
      ),
    );
  }
}
