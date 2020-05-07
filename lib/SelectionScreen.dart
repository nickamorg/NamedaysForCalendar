import 'package:flutter/material.dart';
import 'nameday.dart';
import 'OverviewScreen.dart';

class SelectionScreen extends StatelessWidget {
	final List<NameDay> selectedNameDays;
	final String calendarID;

  	SelectionScreen({Key key, @required this.calendarID, @required this.selectedNameDays}) : super(key: key);

	@override
	Widget build(BuildContext context) {
		return SelectNamedays(calendarID: calendarID, selectedNameDays: selectedNameDays);
	}
}

class SelectNamedaysState extends State<SelectNamedays> {
	NameDays nameDays;
	List<NameDay> selectedNameDays = new List<NameDay>();
	final _biggerFont = const TextStyle(fontSize: 18.0);
	String calendarID;
	final searchNdayCtrl = TextEditingController();
	int alreadySavedNamedays = -1;
	
  	@override
	Widget build(BuildContext context) {
		selectedNameDays = widget.selectedNameDays;
		calendarID = widget.calendarID;

		if (alreadySavedNamedays == -1) alreadySavedNamedays = selectedNameDays.length;
		
		return Scaffold(
			appBar: AppBar(
				title: Text('Επιλογή Εορτών'),
				actions: <Widget>[
					Visibility(
						visible: selectedNameDays.length > alreadySavedNamedays,
						child: IconButton(icon: Icon(Icons.format_list_numbered), onPressed: selectNamedays),
					)
				],
			),
			body: loadListView(),
		);
	}

	void selectNamedays() {
		Navigator.push(
			context,
			MaterialPageRoute(
				builder: (context) => OverviewScreen(calendarID: calendarID, selectedNameDays: selectedNameDays),
        	)
		).then((val) => alreadySavedNamedays = selectedNameDays.length);
	}

	Widget loadListView() {
		return Column(
			children:[
				Container(
					padding: const EdgeInsets.all(20.0),
					child: new Center(
						child: TextField(
							decoration: InputDecoration(
								border: new OutlineInputBorder(
									borderRadius: const BorderRadius.all(
									    const Radius.circular(6.0),
									),
								),
								hintText: 'Αναζήτηση Ονομαστικής Εορτής',
							),
							controller: searchNdayCtrl,
							onChanged: (text) {
								setState(() {});   // Redraw the Stateful Widget
							},
                            autofocus: true,
						),
					)
				),
				Expanded(
					child: loadNamedays()
				)
			]
		);
	}

    Widget loadNamedays() {
        int namedaysCount = NameDays.nameDaysList.where((val) => val > searchNdayCtrl.text).length;
        int alreadySavedCount = selectedNameDays.where((val) => val > searchNdayCtrl.text && val.eventID != null).length;

        if (alreadySavedCount > 10 || (namedaysCount - alreadySavedCount) > 1) {
            namedaysCount++;

            return ListView.builder(
                padding: const EdgeInsets.all(1.0),
                itemCount: namedaysCount,
                itemBuilder: (BuildContext ctxt, int index) {
                    return index == 0 ? selectAllItem() : loadNameday(NameDays.nameDaysList.where((val) => val > searchNdayCtrl.text).toList(growable: true)[index - 1]);
                }
            );
        }

        return ListView.builder(
            padding: const EdgeInsets.all(1.0),
            itemCount: namedaysCount,
            itemBuilder: (BuildContext ctxt, int index) {
               return loadNameday(NameDays.nameDaysList.where((val) => val > searchNdayCtrl.text).toList(growable: true)[index]);
            }
        );
    }
    
	Widget selectAllItem() {
		bool areAllSelected = selectedNameDays.where((nameday) => nameday > searchNdayCtrl.text).length == NameDays.nameDaysList.where((nameday) => nameday > searchNdayCtrl.text).length;

		return new ListTile(
			leading: Checkbox(
				value: areAllSelected,
				onChanged: null,
			),
			title: Text(
				(areAllSelected ? 'Αποεπιλογή' : 'Επιλογή') + ' Όλων',
				style: _biggerFont,
			),
			trailing: Text(
				selectedNameDays.where((nameday) => nameday > searchNdayCtrl.text && nameday.eventID == null).length.toString() + '/' + ((NameDays.nameDaysList.where((nameday) => nameday > searchNdayCtrl.text && nameday.eventID == null).length - selectedNameDays.where((nameday) => nameday > searchNdayCtrl.text && nameday.eventID != null).length).toString()),
				style: _biggerFont,
			),
			onTap: () {
				setState(() {
					if (areAllSelected) {
						for (var i = selectedNameDays.length - 1; i >= 0; i--) {
							if (selectedNameDays[i].eventID == null)
								selectedNameDays.removeAt(i);
						}
					} else {
						NameDays.nameDaysList.where((val) => val > searchNdayCtrl.text).forEach((nameday) {
							if (!selectedNameDays.contains(nameday))
								selectedNameDays.add(nameday);
						}); 
					}
				});
			},
		);
	}

	Widget loadNameday(NameDay pair) {
		final bool alreadySelected = selectedNameDays != null ? selectedNameDays.contains(pair) : false;
		final bool alreadySaved = selectedNameDays != null ? (selectedNameDays.indexOf(pair) == -1 ? false : selectedNameDays[selectedNameDays.indexOf(pair)].eventID != null) : false;

		if (pair.hypocorisms.isNotEmpty) {
			return new Tooltip(
				margin:  const EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 0),
				textStyle:  const TextStyle(color: Colors.black),
				decoration: BoxDecoration(
					color: Colors.white,
					border: Border.all(color: Colors.black, width: 3.0),
					borderRadius: BorderRadius.all(Radius.circular(6.0))
				),
				message: pair.hypocorisms,
				child: ListTile(
					leading: Checkbox(
						value: alreadySelected,
						onChanged: null,
					),
					title: Text(
						pair.name,
						style: _biggerFont,
					),
					trailing: Text(
						pair.date
					),
					enabled: !alreadySaved,
					onTap: () {
						setState(() {
							alreadySelected ? selectedNameDays.remove(pair) : selectedNameDays.add(pair);
						});
					},
				)
			);
		} else {
			return new ListTile(
				leading: Checkbox(
					value: alreadySelected,
					onChanged: null,
				),
				title: Text(
					pair.name,
					style: _biggerFont,
				),
				trailing: Text(
					pair.date
				),
				enabled: !alreadySaved,
				onTap: () {
					setState(() {
						alreadySelected ? selectedNameDays.remove(pair) : selectedNameDays.add(pair);
					});
				},
			);
		}
	}
}

class SelectNamedays extends StatefulWidget {
	final List<NameDay> selectedNameDays;
	final String calendarID;

	SelectNamedays({Key key, this.calendarID, this.selectedNameDays}) : super(key: key);

	@override
	State createState() => SelectNamedaysState();
}