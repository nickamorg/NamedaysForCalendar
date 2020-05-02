import 'package:flutter/material.dart';
import 'package:manage_calendar_events/manage_calendar_events.dart';
import 'nameday.dart';
import 'selection_screen.dart';

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
	List<NameDay> savedNamedays = new List<NameDay>();
	List<NameDay> selectedNameDays = new List<NameDay>();
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
					savedNamedays = new List<NameDay>();
					val.forEach((event) {
						if (event.title.contains("🎂 Ονομαστική Εορτή: ")) {
							String name = event.title.split(" ")[event.title.split(" ").length - 1];
							String date = (event.startDate.day < 10? "0" : "") + event.startDate.day.toString() + "-" + (event.startDate.month < 10? "0" : "") + event.startDate.month.toString() + "-" + event.startDate.year.toString();

							savedNamedays.add(new NameDay(name: name, date: date, saved: true, eventID: event.eventId));
						}
					});
				});
			});
		});
	}

  	@override
	Widget build(BuildContext context) {
		if (savedNamedays == null) {
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
			),
			body: loadNamedays(),
			floatingActionButton: Stack(
				children: <Widget>[
					Padding(padding: EdgeInsets.only(left:31),
						child: Align(
							alignment: Alignment.bottomLeft,
							child: Visibility(
								child:FloatingActionButton(
									backgroundColor: Colors.red,
									onPressed: () {
										setState(() {
											deleteNamedayEvents();
										});
									},
									child: Icon(Icons.delete),
								),
								visible: selectedNameDays.length > 0,
							)
						),
					),

					Align(
						alignment: Alignment.bottomRight,
						child: FloatingActionButton(
							onPressed: (() {
								setState(() {
									selectedNameDays.clear();
								});
								
								Navigator.push(
									context,
									MaterialPageRoute(
										builder: (context) => SelectionScreen(calendarID: calendarID, selectedNameDays: savedNamedays,
									),
								));
							}),
						child: Icon(Icons.add)),
					),
				],
			)
		);
	}

	Widget loadNamedays() {
		return ListView.builder(
			padding: const EdgeInsets.all(1.0),
			itemCount: savedNamedays.length,
			itemBuilder: (BuildContext ctxt, int index) {
				return loadNameday(savedNamedays[index]);
			}
		);
	}

	Widget loadNameday(NameDay pair) {
		final bool alreadySaved = selectedNameDays != null ? selectedNameDays.contains(pair) : false;

		if (pair.hypocorisms != null) {
			return new Tooltip(
				padding: const EdgeInsets.all(10.0),
				margin: const EdgeInsets.all(20.0),
				textStyle: const TextStyle(color: Colors.black),
				decoration: BoxDecoration(color: Colors.white, border: Border.all(color: Colors.black, width: 3.0), borderRadius: BorderRadius.all(Radius.circular(6.0))),
				message: pair.hypocorisms,
				child: ListTile(
					title: Text(
						pair.name,
						style: _biggerFont,
					),
					trailing: Text(
						pair.date
					),
					onLongPress: () {
						setState(() {
							if (alreadySaved) {
								selectedNameDays.remove(pair);
							} else {
								selectedNameDays.add(pair); 
							} 
						});
					},

					onTap: () {
						if (selectedNameDays.length > 0) {
							setState(() {
								if (alreadySaved) {
									selectedNameDays.remove(pair);
								} else {
									selectedNameDays.add(pair); 
								} 
							});
						}
					},
				)
			);
		} else {
			return new Container(
				child: ListTile(
					title: Text(
						pair.name,
						style: TextStyle(color: alreadySaved != true ? Colors.black : Colors.white, fontSize: 18),
					),
					trailing: Text(
						pair.date,
						style: TextStyle(color: alreadySaved != true ? Colors.black : Colors.white),
					),
					onLongPress: () {
						setState(() {
							if (alreadySaved) {
								selectedNameDays.remove(pair);
							} else {
								selectedNameDays.add(pair); 
							} 
						});
					},

					onTap: () {
						if (selectedNameDays.length > 0) {
							setState(() {
								if (alreadySaved) {
									selectedNameDays.remove(pair);
								} else {
									selectedNameDays.add(pair); 
								} 
							});
						}
					},
				),
				color: (alreadySaved != true ? Colors.white : Colors.grey),
			);
		}
	}

	void deleteNamedayEvents() {
		selectedNameDays.forEach((nameday) {
			new CalendarPlugin().deleteEvent(calendarId: calendarID, eventId: nameday.eventID);
			savedNamedays.remove(nameday);
		});

		selectedNameDays.clear();
	}
}

class RandomWords extends StatefulWidget {
	@override
	State createState() => RandomWordsState();
}