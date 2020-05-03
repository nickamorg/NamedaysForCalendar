import 'package:flutter/material.dart';
import 'nameday.dart';
import 'OverviewScreen.dart';

class SelectionScreen extends StatelessWidget {
	final List<NameDay> selectedNameDays;
	final String calendarID;

  	SelectionScreen({Key key, @required this.calendarID, @required this.selectedNameDays}) : super(key: key);

	@override
	Widget build(BuildContext context) {
		return SelectNamedays(selectedNameDays: selectedNameDays);
	}
}

class SelectNamedaysState extends State<SelectNamedays> {
	final NameDays nameDays = new NameDays(true);
	NameDays selectedNameDays = new NameDays(false);
	final _biggerFont = const TextStyle(fontSize: 18.0);
	String calendarID;
	final searchNdayCtrl = TextEditingController();

  	@override
	Widget build(BuildContext context) {
		selectedNameDays.nameDaysList = widget.selectedNameDays;

		if (selectedNameDays == null) {
			return new Container(
				margin: const EdgeInsets.all(10.0),
				color: Colors.blue,
				width: 48.0,
				height: 48.0,
			);
		}
		
		return Scaffold(
			appBar: AppBar(
				title: Text('Επιλογή Εορτών'),
				actions: <Widget>[
					IconButton(icon: Icon(Icons.add), onPressed: selectNamedays),
				],
			),
			body: loadNamedays(),
		);
	}

	void selectNamedays() {
		Navigator.push(
			context,
			MaterialPageRoute(
				builder: (context) => OverviewScreen(calendarID: calendarID, selectedNameDays: selectedNameDays.nameDaysList,
			),
        ));
	}

	Widget loadNamedays() {
		
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
						),
					)
				),
				Expanded(
					child: ListView.builder(
						padding: const EdgeInsets.all(1.0),
						itemCount: nameDays.nameDaysList.where((val) => val > searchNdayCtrl.text).length,
						itemBuilder: (BuildContext ctxt, int index) {
							return loadNameday(nameDays.nameDaysList.where((val) => val > searchNdayCtrl.text).toList(growable: true)[index]);
						}
					)
				)
			]
		);
	}

	Widget loadNameday(NameDay pair) {
		final bool alreadySelected = selectedNameDays != null ? selectedNameDays.nameDaysList.contains(pair) : false;
		final bool alreadySaved = selectedNameDays != null ? (selectedNameDays.nameDaysList.indexOf(pair) == -1 ? false : selectedNameDays.nameDaysList[selectedNameDays.nameDaysList.indexOf(pair)].saved) : false;

		if (pair.hypocorisms.isNotEmpty) {
			return new Tooltip(
				padding: const EdgeInsets.all(10.0),
				margin:  const EdgeInsets.all(20.0),
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
							if (alreadySelected) {
								selectedNameDays.nameDaysList.remove(pair);
							} else {
								selectedNameDays.nameDaysList.add(pair);
							} 
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
						if (alreadySelected) {
							selectedNameDays.nameDaysList.remove(pair);
						} else {
							selectedNameDays.nameDaysList.add(pair);
						} 
					});
				},
			);
		}
	}
}

class SelectNamedays extends StatefulWidget {
	List<NameDay> selectedNameDays;

	SelectNamedays({Key key,this.selectedNameDays}) : super(key: key);

	@override
	State createState() => SelectNamedaysState();
}