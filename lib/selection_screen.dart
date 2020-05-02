import 'package:flutter/material.dart';
import 'nameday.dart';
import 'overview_screen.dart';

class SelectionScreen extends StatelessWidget {
	final List<NameDay> selectedNameDays;
	final String calendarID;

  	SelectionScreen({Key key, @required this.calendarID, @required this.selectedNameDays}) : super(key: key);

	@override
	Widget build(BuildContext context) {
		return RandomWords(selectedNameDays: selectedNameDays);
	}
}

class RandomWordsState extends State<RandomWords> {
	final NameDays nameDays = new NameDays();
	List<NameDay> selectedNameDays;
	final _biggerFont = const TextStyle(fontSize: 18.0);
	String calendarID;

  	@override
	Widget build(BuildContext context) {
		selectedNameDays = widget.selectedNameDays;

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
				builder: (context) => OverviewScreen(calendarID: calendarID, selectedNameDays: selectedNameDays,
			),
        ));
	}

	Widget loadNamedays() {
		return ListView.builder(
			padding: const EdgeInsets.all(1.0),
			itemCount: nameDays.nameDaysList.length,
				itemBuilder: (BuildContext ctxt, int index) {
					return loadNameday(nameDays.nameDaysList[index]);
				}
			);
	}

	Widget loadNameday(NameDay pair) {
		final bool alreadySaved = selectedNameDays != null ? selectedNameDays.contains(pair) : false;

		if (pair.hypocorisms != null) {
			return new Tooltip(
			padding: const EdgeInsets.all(10.0),
			margin:  const EdgeInsets.all(20.0),
			textStyle:  const TextStyle(color: Colors.black),
			decoration: BoxDecoration(color: Colors.white, border: Border.all(color: Colors.black, width: 3.0), borderRadius: BorderRadius.all(Radius.circular(6.0))),
			message: pair.hypocorisms,
			child: ListTile(
				leading: Checkbox(
					value: alreadySaved,
					onChanged: null,
				),
				title: Text(
					pair.name,
					style: _biggerFont,
				),
				trailing: Text(
					pair.date
				),
				onTap: () {
					setState(() {
						if (alreadySaved) {
							selectedNameDays.remove(pair);
						} else {
							selectedNameDays.add(pair); 
						} 
					});
				},
			)
		);
		} else {
			return new ListTile(
				leading: Checkbox(
					value: alreadySaved,
					onChanged: null,
				),
				title: Text(
					pair.name,
					style: _biggerFont,
				),
				trailing: Text(
					pair.date
				),
				onTap: () {
					setState(() {
						if (alreadySaved) {
							selectedNameDays.remove(pair);
						} else {
							selectedNameDays.add(pair); 
						} 
					});
				},
		);
		}
		
	}
}

class RandomWords extends StatefulWidget {
	List<NameDay> selectedNameDays;
	RandomWords({Key key,this.selectedNameDays}) : super(key: key);

	@override
	State createState() => RandomWordsState();
}