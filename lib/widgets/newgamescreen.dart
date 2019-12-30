import 'package:flutter/material.dart';
import 'package:rook_flutter/models/player.dart';
import 'package:rook_flutter/models/newgame.dart';

List<Player> players = [Player('Martin'),Player('Brad')];



class PartnerSelection extends NewGameExpandableItem {

  final List<Player> players;

  PartnerSelection(NewGame newGame,this.players,{bool isExpanded=false}) : super(newGame,isExpanded);

  @override
  ExpansionPanel create (State expandedState,List<NewGameExpandableItem> items){
    return ExpansionPanel(
      headerBuilder: (BuildContext context, bool isExpanded) {
//        return ListTile(
//          title: Text(newGame.partners.length>0?newGame.partners.map((player)=>player.name).join(','):'No Partners'),
//        );

        if(newGame.partners.length==0){
          return Text('No Partners');
        }else{
          return Row(
                children: newGame.partners.map<RaisedButton>((Player player) {
                  return RaisedButton(
                    onPressed: () {
                      expandedState.setState(() {
                        newGame.partners.remove(player);
                      });
                    },
                    child: Text(
                        player.name,
                        style: TextStyle(fontSize: 16)
                    ),
                  );
                }).toList()
            );
        }

        return Text(newGame.partners.length>0?newGame.partners.map((player)=>player.name).join(','):'No Partners');
//      return Dismissible(
//        key: Key('player'),
//        onDismissed: (direction){
//          expandedState.setState(() {
//              newGame.partners.clear();
//          });
//          Text('No Partners');
////          Scaffold
////              .of(context)
////              .showSnackBar(SnackBar(content: Text("dismissed")));
//        },
//        child: Text(newGame.partners.length>0?newGame.partners.map((player)=>player.name).join(','):'No Partners'),
//      );
      },
      body: Container(
        child: Row(
            children: players.map<RaisedButton>((Player player) {
              return RaisedButton(
                onPressed: () {
                  expandedState.setState(() {
                    newGame.partners.add(player);
                  });
                },
                child: Text(
                    player.name,
                    style: TextStyle(fontSize: 20)
                ),
              );
            }).toList()
        ),
      ),
      isExpanded: isExpanded,
    );
  }
}



class CallerSelection extends NewGameExpandableItem {

  final List<Player> players;

  CallerSelection(NewGame newGame,this.players,{bool isExpanded=false}) : super(newGame,isExpanded);

  @override
  ExpansionPanel create (State expandedState,List<NewGameExpandableItem> items){
    return ExpansionPanel(
      headerBuilder: (BuildContext context, bool isExpanded) {
        return ListTile(
          title: Text(newGame.bidder!=null?"Bidder: "+newGame.bidder.name:'Select Caller'),
        );
      },
      body: Container(
        child: Row(
            children: players.map<RaisedButton>((Player player) {
              return RaisedButton(
                onPressed: () {
                  expandedState.setState(() {
                    newGame.bidder == player
                        ? newGame.bidder = null
                        : newGame.bidder = player;
                    isExpanded=false;//we made a selection unexpand section
                  });
                },
                child: Text(
                    player.name,
                    style: TextStyle(fontSize: 20)
                ),
              );
            }).toList()
        ),
      ),
      isExpanded: isExpanded,
    );
  }
}

class SliderItem extends NewGameExpandableItem {

  SliderItem(NewGame newGame,{bool isExpanded=false}) : super(newGame,isExpanded);

  @override
  ExpansionPanel create (State expandState,List<NewGameExpandableItem> items){
    return ExpansionPanel(
      headerBuilder: (BuildContext context, bool isExpanded) {
        return ListTile(
          title: Text("Current Bid: "+newGame.bid.toString()),
        );
      },
      body: SliderWidget(newGame,expandState),
      isExpanded: isExpanded,
    );
  }
}


class SliderWidget extends StatefulWidget {

  final NewGame newGame;
  final State expandState;

  SliderWidget(this.newGame,this.expandState);

  @override
  SliderState createState() => SliderState(newGame,expandState);
}

class SliderState extends State<SliderWidget> {
  NewGame newGame;
  State expandState;

  SliderState(this.newGame,this.expandState);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Slider(
        value: newGame.bid,
        min: 100,
        max: 180,
        divisions: 16,
        label: 'Bid',
        onChanged: (newrating){
          setState(() {
            newGame.bid=newrating;
          });
          expandState.setState(() {
            newGame.bid=newrating;
          });
        },
      ),
    );
  }
}

// For testing
class BasicItem extends NewGameExpandableItem {

  BasicItem(NewGame newGame,{bool isExpanded=false}) : super(newGame,isExpanded);

  @override
  ExpansionPanel create (State state,List<NewGameExpandableItem> items){
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

  final NewGame newGame;
  bool isExpanded = false;

  NewGameExpandableItem(
      this.newGame,
      this.isExpanded,
      );


  ExpansionPanel create (State state,List<NewGameExpandableItem> items);

}

class ExpansionStateWidget extends StatefulWidget {

  final NewGame newGame;
  ExpansionStateWidget(this.newGame,{Key key}) : super(key: key);

  @override
  ExpansionControls createState() => ExpansionControls(newGame);
}

class ExpansionControls extends State<ExpansionStateWidget> {

  NewGame newGame;
  List<NewGameExpandableItem> newItems;


  ExpansionControls(NewGame newGame){
    this.newGame=newGame;
    newItems = [
      CallerSelection(newGame,players),
      SliderItem(newGame),
      PartnerSelection(newGame,players),
      BasicItem(newGame)
    ];
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: _buildPanel(),
      ),
    );
  }

  Widget _buildPanel() {
    return ExpansionPanelList(
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          newItems[index].isExpanded = !isExpanded;
        });
      },
      children: newItems.map<ExpansionPanel>((NewGameExpandableItem item) {
        return item.create(this, newItems);
      }).toList(),
    );
  }
}

