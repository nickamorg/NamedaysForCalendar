import 'package:flutter/material.dart';
import 'package:manage_calendar_events/manage_calendar_events.dart';
import 'nameday.dart';
import 'overview_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
	@override
	Widget build(BuildContext context) {
		return MaterialApp(
			title: 'Εορτολόγιο',
			home: RandomWords(),
		);
	}
}

class RandomWordsState extends State<RandomWords> {
	final NameDays nameDays = new NameDays();
	List<NameDay> selectedNameDays;
	final _biggerFont = const TextStyle(fontSize: 18.0);
	String calendarID;

	@override
    void initState() {
		super.initState();
		
		new CalendarPlugin().getCalendars().then((calendars) { 
			calendars.forEach((val) { 
				if(val.name.contains("@gmail.com")) calendarID = val.id;
			});

			new CalendarPlugin().getEvents(calendarId:calendarID).then((val) {
				setState(() {
					selectedNameDays = new List<NameDay>();
					val.forEach((event) {
						if (event.title.contains("🎂 Ονομαστική Εορτή: ")) {
							String name = event.title.split(" ")[event.title.split(" ").length - 1];
							String date = (event.startDate.day < 10? "0" : "") + event.startDate.day.toString() + "-" + (event.startDate.month < 10? "0" : "") + event.startDate.month.toString() + "-" + event.startDate.year.toString();

							selectedNameDays.add(new NameDay(name: name, date: date));
						}
					});
				});
			});
		});
	}

  	@override
	Widget build(BuildContext context) {
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
				title: Text('Εορτολόγιο'),
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
				builder: (context) => DetailScreen(calendarID: calendarID, selectedNameDays: selectedNameDays,
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
	@override
	State createState() => RandomWordsState();
}