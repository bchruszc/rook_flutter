import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rook_flutter/models/game.dart';

class CallerSelection extends NewGameExpandableItem {
  final List<Player> players;

  CallerSelection(Match newMatch, this.players, {bool isExpanded = false})
      : super(newMatch, isExpanded, false);

  @override
  ExpansionPanel create(State expandedState, List<NewGameExpandableItem> items,
      BuildContext context) {
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
                    doLockAndEnableLogic(newMatch, items);
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

class BidSliderItem extends NewGameExpandableItem {
  BidSliderItem(Match newMatch,
      {bool isExpanded = false, bool isLocked = false})
      : super(newMatch, isExpanded, isLocked);

  @override
  ExpansionPanel create(State expandState, List<NewGameExpandableItem> items,
      BuildContext context) {
    return ExpansionPanel(
      headerBuilder: (BuildContext context, bool isExpanded) {
        return ListTile(
          title: Text("Current Bid: " + newMatch.bid.toString()),
        );
      },
      body: BidSliderWidget(newMatch, expandState),
      isExpanded: isExpanded,
    );
  }
}

class BidSliderWidget extends StatefulWidget {
  final Match newMatch;
  final State expandState;

  BidSliderWidget(this.newMatch, this.expandState);

  @override
  BidSliderState createState() => BidSliderState(newMatch, expandState);
}

class BidSliderState extends State<BidSliderWidget> {
  Match newMatch;
  State expandState;

  BidSliderState(this.newMatch, this.expandState);

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

class PartnerSelection extends NewGameExpandableItem {
  final List<Player> players;

  PartnerSelection(Match newMatch, this.players,
      {bool isExpanded = false, bool isLocked = false})
      : super(newMatch, isExpanded, isLocked);

  @override
  ExpansionPanel create(State expandedState, List<NewGameExpandableItem> items,
      BuildContext context) {
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
                      doLockAndEnableLogic(newMatch, items);
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
                    doLockAndEnableLogic(newMatch, items);
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

class MadeSliderItem extends NewGameExpandableItem {
  MadeSliderItem(Match newMatch,
      {bool isExpanded = false, bool isLocked = false})
      : super(newMatch, isExpanded, isLocked);

  @override
  ExpansionPanel create(State expandState, List<NewGameExpandableItem> items,
      BuildContext context) {
    return ExpansionPanel(
      headerBuilder: (BuildContext context, bool isExpanded) {
        return ListTile(
          title: Text("Made: " +
              newMatch.madeValue().toString() +
              " Lost: " +
              newMatch.lostValue().toString()),
        );
      },
      body: MadeSliderWidget(newMatch, expandState),
      isExpanded: isExpanded,
    );
  }
}

class MadeSliderWidget extends StatefulWidget {
  final Match newMatch;
  final State expandState;

  MadeSliderWidget(this.newMatch, this.expandState);

  @override
  MadeSliderState createState() => MadeSliderState(newMatch, expandState);
}

class MadeSliderState extends State<MadeSliderWidget> {
  Match newMatch;
  State expandState;

  MadeSliderState(this.newMatch, this.expandState);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Slider(
        value: newMatch.made,
        min: 100,
        max: 180,
        divisions: 16,
        label: 'Made',
        onChanged: (newrating) {
          setState(() {
            newMatch.made = newrating;
          });
          expandState.setState(() {
            newMatch.made = newrating;
          });
        },
      ),
    );
  }
}

// For testing
class BasicItem extends NewGameExpandableItem {
  BasicItem(Match newMatch, {bool isExpanded = false})
      : super(newMatch, isExpanded, true);

  @override
  ExpansionPanel create(
      State state, List<NewGameExpandableItem> items, BuildContext context) {
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
  final Match newMatch;
  bool isExpanded = false;
  bool
      isLocked; //want to try and lock the other items if the ones before are not set yet
  //do this through streams, hierarchy?

  NewGameExpandableItem(this.newMatch, this.isExpanded, this.isLocked);

  ExpansionPanel create(
      State state, List<NewGameExpandableItem> items, BuildContext context);
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
  ExpansionControls createState() => ExpansionControls(Match(), game);
}

class ExpansionControls extends State<ExpansionStateWidget> {
  Match newMatch;
  GameInfo game;
  List<NewGameExpandableItem> newItems;

  ExpansionControls(Match newMatch, GameInfo game) {
    this.newMatch = newMatch;
    this.game = game;
    newItems = [
      CallerSelection(newMatch, game.players),
      BidSliderItem(newMatch, isLocked: true),
      PartnerSelection(newMatch, game.players, isLocked: true),
      MadeSliderItem(newMatch, isLocked: true)
    ];
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: buildPanel(context),
      ),
    );
  }

  Widget buildPanel(BuildContext context) {
    return SafeArea(
      child: ExpansionPanelList(
        expansionCallback: (int index, bool isExpanded) {
          if (!newItems[index].isLocked) {
            setState(() {
              newItems[index].isExpanded = !isExpanded;
            });
          }
        },
        children: newItems.map<ExpansionPanel>((NewGameExpandableItem item) {
          return item.create(this, newItems, context);
        }).toList(),
      ),
    );
  }
}

doLockAndEnableLogic(Match match, List<NewGameExpandableItem> items) {
  if (match.bidder != null) {
    items[1].isExpanded = true;
    items[1].isLocked = false;
    items[2].isExpanded = true;
    items[2].isLocked = false;
  } else {
    items[1].isExpanded = false;
    items[1].isLocked = true;
    items[2].isExpanded = false;
    items[2].isLocked = true;
  }

  if (match.isMatchSetup()) {
    items[3].isExpanded = true;
    items[3].isLocked = false;
  } else {
    items[3].isExpanded = false;
    items[3].isLocked = true;
  }
}
