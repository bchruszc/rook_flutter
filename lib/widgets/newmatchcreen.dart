import 'package:flutter/material.dart';
import 'package:rook_flutter/models/game.dart';

List<Player> players = [Player('Martin'),Player('Brad')];



class PartnerSelection extends NewGameExpandableItem {

  final List<Player> players;

  PartnerSelection(NewMatch newMatch,this.players,{bool isExpanded=false}) : super(newMatch,isExpanded);

  @override
  ExpansionPanel create (State expandedState,List<NewGameExpandableItem> items){
    return ExpansionPanel(
      headerBuilder: (BuildContext context, bool isExpanded) {
//        return ListTile(
//          title: Text(newMatch.partners.length>0?newMatch.partners.map((player)=>player.name).join(','):'No Partners'),
//        );

        if(newMatch.partners.length==0){
          return Text('No Partners');
        }else{
          return Row(
                children: newMatch.partners.map<FlatButton>((Player player) {
                  return FlatButton(
                    onPressed: () {
                      expandedState.setState(() {
                        newMatch.partners.remove(player);
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

        return Text(newMatch.partners.length>0?newMatch.partners.map((player)=>player.name).join(','):'No Partners');
//      return Dismissible(
//        key: Key('player'),
//        onDismissed: (direction){
//          expandedState.setState(() {
//              newMatch.partners.clear();
//          });
//          Text('No Partners');
////          Scaffold
////              .of(context)
////              .showSnackBar(SnackBar(content: Text("dismissed")));
//        },
//        child: Text(newMatch.partners.length>0?newMatch.partners.map((player)=>player.name).join(','):'No Partners'),
//      );
      },
      body: Container(
        child: Row(
            children: players.map<RaisedButton>((Player player) {
              return RaisedButton(
                onPressed: () {
                  expandedState.setState(() {
                    newMatch.partners.add(player);
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

  CallerSelection(NewMatch newMatch,this.players,{bool isExpanded=false}) : super(newMatch,isExpanded);

  @override
  ExpansionPanel create (State expandedState,List<NewGameExpandableItem> items){
    return ExpansionPanel(
      headerBuilder: (BuildContext context, bool isExpanded) {
        return ListTile(
          title: Text(newMatch.bidder!=null?"Bidder: "+newMatch.bidder.name:'Select Caller'),
        );
      },
      body: Container(
        child: Row(
            children: players.map<RaisedButton>((Player player) {
              return RaisedButton(
                onPressed: () {
                  expandedState.setState(() {
                    newMatch.bidder == player
                        ? newMatch.bidder = null
                        : newMatch.bidder = player;
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

  SliderItem(NewMatch newMatch,{bool isExpanded=false}) : super(newMatch,isExpanded);

  @override
  ExpansionPanel create (State expandState,List<NewGameExpandableItem> items){
    return ExpansionPanel(
      headerBuilder: (BuildContext context, bool isExpanded) {
        return ListTile(
          title: Text("Current Bid: "+newMatch.bid.toString()),
        );
      },
      body: SliderWidget(newMatch,expandState),
      isExpanded: isExpanded,
    );
  }
}


class SliderWidget extends StatefulWidget {

  final NewMatch newMatch;
  final State expandState;

  SliderWidget(this.newMatch,this.expandState);

  @override
  SliderState createState() => SliderState(newMatch,expandState);
}

class SliderState extends State<SliderWidget> {
  NewMatch newMatch;
  State expandState;

  SliderState(this.newMatch,this.expandState);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Slider(
        value: newMatch.bid,
        min: 100,
        max: 180,
        divisions: 16,
        label: 'Bid',
        onChanged: (newrating){
          setState(() {
            newMatch.bid=newrating;
          });
          expandState.setState(() {
            newMatch.bid=newrating;
          });
        },
      ),
    );
  }
}

// For testing
class BasicItem extends NewGameExpandableItem {

  BasicItem(NewMatch newMatch,{bool isExpanded=false}) : super(newMatch,isExpanded);

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

  final NewMatch newMatch;
  bool isExpanded = false;

  NewGameExpandableItem(
      this.newMatch,
      this.isExpanded,
      );


  ExpansionPanel create (State state,List<NewGameExpandableItem> items);

}

class ExpansionStateWidget extends StatefulWidget {

  final NewMatch newMatch;
  ExpansionStateWidget(this.newMatch,{Key key}) : super(key: key);

  @override
  ExpansionControls createState() => ExpansionControls(newMatch);
}

class ExpansionControls extends State<ExpansionStateWidget> {

  NewMatch newMatch;
  List<NewGameExpandableItem> newItems;


  ExpansionControls(NewMatch newMatch){
    this.newMatch=newMatch;
    newItems = [
      CallerSelection(newMatch,players),
      SliderItem(newMatch),
      PartnerSelection(newMatch,players),
      BasicItem(newMatch)
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
