import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frideos/frideos.dart';
import 'package:frideos_core/frideos_core.dart';
import 'package:rook_flutter/models/game.dart';
import 'package:rook_flutter/shared/inheritedprovider.dart';
import 'package:rook_flutter/widgets/scorescreen.dart';

//typedef WidgetBuilder = Widget Function(BuildContext context,int index);

//Entry
class NewMatchWidget extends StatefulWidget {
  static const String Id = '/NewMatch';
  GameInfo game;

  NewMatchWidget({Key key, @required this.game}) : super(key: key);

  @override
  NewMatchWidgetState createState() => NewMatchWidgetState();
}

class NewMatchWidgetState extends State<NewMatchWidget> {
  final StreamedValue<bool> disableButton = StreamedValue();

  @override
  void initState() {
    super.initState();
    widget.game.matches.add(Match(widget.game.players.length));
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
        title: Text("New Match"),
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
      body: new Builder(
        builder: (context) {
          return ExpansionStateWidget(widget.game, disableButton);
        },
      ),
    );
  }
}

class CallerSelection extends NewMatchExpandableItem {
  final HashSet<Player> players;

  CallerSelection(Match newMatch, this.players, {bool isExpanded = true})
      : super(newMatch, isExpanded, false);

  @override
  ExpansionPanel create(State expandedState, List<NewMatchExpandableItem> items,
      BuildContext context) {
    return ExpansionPanel(
      headerBuilder: (BuildContext context, bool isExpanded) {
        return ListTile(
          title: Text(
              newMatch.bidder != null
                  ? "Bidder: " + newMatch.bidder.name
                  : 'Select Caller',
              style: TextStyle(
                fontSize: 18,
              )),
        );
      },
      body: Container(
        child: IntrinsicWidth(
          child: Wrap(
              direction: Axis.horizontal,
              children: players.map<Widget>((Player player) {
                return Container(
                    margin: EdgeInsets.only(left: 5.0, right: 5.0),
                    child: RaisedButton(
                      onPressed: () {
                        expandedState.setState(() {
                          newMatch.bidder == player
                              ? newMatch.bidder = null
                              : newMatch.bidder = player;
                          isExpanded =
                              false; //we made a selection unexpand section
                          doLockAndEnableLogic(newMatch, items);
                        });
                      },
                      child: Text(player.name, style: TextStyle(fontSize: 16)),
                    ));
              }).toList()),
        ),
      ),
      isExpanded: isExpanded,
    );
  }
}

class BidSliderItem extends NewMatchExpandableItem {
  BidSliderItem(Match newMatch,
      {bool isExpanded = false, bool isLocked = false})
      : super(newMatch, isExpanded, isLocked);

  @override
  ExpansionPanel create(State expandState, List<NewMatchExpandableItem> items,
      BuildContext context) {
    return ExpansionPanel(
      headerBuilder: (BuildContext context, bool isExpanded) {
        return ListTile(
          title: Text("Current Bid: " + newMatch.bid.toString(),
              style: TextStyle(
                fontSize: 18,
              )),
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
            newMatch.made = newrating;
          });
          expandState.setState(() {
            newMatch.bid = newrating;
          });
        },
      ),
    );
  }
}

class PartnerSelection extends NewMatchExpandableItem {
  final HashSet<Player> players;

  PartnerSelection(Match newMatch, this.players,
      {bool isExpanded = false, bool isLocked = false})
      : super(newMatch, isExpanded, isLocked);

  @override
  ExpansionPanel create(State expandedState, List<NewMatchExpandableItem> items,
      BuildContext context) {
    return ExpansionPanel(
      headerBuilder: (BuildContext context, bool isExpanded) {
        if (newMatch.partners.length == 0) {
          return ListTile(
            title: Text("No Partner(s)",
                style: TextStyle(
                  fontSize: 18,
                )),
          );
        } else {
          return IntrinsicWidth(
            child: Container(
              margin: EdgeInsets.only(left: 5.0, right: 5.0),
              child: Wrap(
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
                }).toList(),
              ),
            ),
          );
        }
      },
      body: Container(
        child: IntrinsicWidth(
          child: Wrap(
              direction: Axis.horizontal,
              children: players.map<Widget>((Player player) {
                return Container(
                    margin: EdgeInsets.only(left: 5.0, right: 5.0),
                    child: RaisedButton(
                      onPressed: () {
                        expandedState.setState(() {
                          if (newMatch.partners.length <
                              newMatch.getNumOfPartners()) {
                            newMatch.partners.add(player);
                          }
                          doLockAndEnableLogic(newMatch, items);
                        });
                      },
                      child: Text(player.name, style: TextStyle(fontSize: 16)),
                    ));
              }).toList()),
        ),
      ),
      isExpanded: isExpanded,
    );
  }
}

class MadeSliderItem extends NewMatchExpandableItem {
  StreamedValue<bool> disableButton;

  MadeSliderItem(Match newMatch, this.disableButton,
      {bool isExpanded = false, bool isLocked = false})
      : super(newMatch, isExpanded, isLocked);

  @override
  ExpansionPanel create(State expandState, List<NewMatchExpandableItem> items,
      BuildContext context) {
    return ExpansionPanel(
      headerBuilder: (BuildContext context, bool isExpanded) {
        return ListTile(
          title: Text(
              "Made: " +
                  newMatch.madeValue().toString() +
                  (newMatch.lostValue() > 0 ? " Lost: " : " Gain: ") +
                  newMatch.lostValue().abs().toString(),
              style: TextStyle(
                color: newMatch.lostValue() > 0 ? Colors.red : Colors.green,
                fontSize: 18,
              )),
        );
      },
      body: new Builder(builder: (context) {
        return MadeSliderWidget(newMatch, disableButton, expandState);
      }),
      isExpanded: isExpanded,
    );
  }
}

class MadeSliderWidget extends StatefulWidget {
  final Match newMatch;
  final State expandState;
  StreamedValue<bool> disableButton;

  MadeSliderWidget(this.newMatch, this.disableButton, this.expandState);

  @override
  MadeSliderState createState() => MadeSliderState(newMatch, expandState);
}

class MadeSliderState extends State<MadeSliderWidget> {
  final Match newMatch;
  final State expandState;

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
          widget.disableButton.value = false;
        },
      ),
    );
  }
}

// stores ExpansionPanel state information
abstract class NewMatchExpandableItem {
  final Match newMatch;
  bool isExpanded = false;
  bool
      isLocked; //want to try and lock the other items if the ones before are not set yet
  //do this through streams, hierarchy?

  NewMatchExpandableItem(this.newMatch, this.isExpanded, this.isLocked);

  ExpansionPanel create(
      State state, List<NewMatchExpandableItem> items, BuildContext context);
}

class ExpansionStateWidget extends StatefulWidget {
  final GameInfo game;
  StreamedValue<bool> disableButton;

  ExpansionStateWidget(this.game, this.disableButton, {Key key})
      : super(key: key);

  @override
  ExpansionControls createState() => ExpansionControls();
}

class ExpansionControls extends State<ExpansionStateWidget> {
  List<NewMatchExpandableItem> newItems;

  @override
  void initState() {
    super.initState();
    newItems = [
      CallerSelection(widget.game.getLatestMatch(), widget.game.players),
      BidSliderItem(widget.game.getLatestMatch(), isLocked: true),
      PartnerSelection(widget.game.getLatestMatch(), widget.game.players,
          isLocked: true),
      MadeSliderItem(widget.game.getLatestMatch(), widget.disableButton,
          isLocked: true)
    ];
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: new Builder(
        builder: (context) {
          return buildPanel(context);
        },
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
        children: newItems.map<ExpansionPanel>((NewMatchExpandableItem item) {
          return item.create(this, newItems, context);
        }).toList(),
      ),
    );
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
      child: Text(
        'Submit',
        style: TextStyle(
            color: disableButton.value ? Colors.grey : Colors.white,
            fontSize: 20),
      ),
      onPressed: () {
        if (widget.game.isLatestMatchSetup() && !disableButton.value) {
          widget.game.getLatestMatch().submitted = true;
          Navigator.pushNamed(context, Scoreboard.Id, arguments: widget.game);
        }
      },
    );
  }
}

doLockAndEnableLogic(Match match, List<NewMatchExpandableItem> items) {
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
    items[1].isExpanded = false;
    items[1].isLocked = false;
    items[2].isExpanded = false;
    items[2].isLocked = false;
    items[3].isExpanded = true;
    items[3].isLocked = false;
  } else {
    items[3].isExpanded = false;
    items[3].isLocked = true;
  }
}
