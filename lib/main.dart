// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'package:flutter/material.dart';
import 'dart:collection';
import 'package:manage_calendar_events/manage_calendar_events.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
	return MaterialApp(
	  title: 'Startup Name Generator',
	  home: RandomWords(),
	);
  }
}

class NameDay {
	String name;
	String date;

	NameDay(String name, String date) {
		this.name = name;
		this.date = date;
	}
}

class NameDays {
	List<NameDay> nameDays;

	NameDays() {
		nameDays = <NameDay>[];
		nameDays.add(new NameDay("Dummy",     '29-04-2020'));
		nameDays.add(new NameDay("Dummy #2",  '30-04-2020'));
		nameDays.add(new NameDay("Dummy #3",  '30-04-2020'));
		nameDays.add(new NameDay("Βασίλειος", '01-01-2020'));
		nameDays.add(new NameDay("Σταμάτης",  '03-02-2020'));
		nameDays.add(new NameDay("Ιωάννης",   '06-03-2020'));
		nameDays.add(new NameDay("Λεωνίδας",  '15-04-2020'));
		nameDays.add(new NameDay("Ιάσονας",   '29-04-2020'));
		nameDays.add(new NameDay("Ιερεμίας",  '01-05-2020'));
		nameDays.add(new NameDay("Αχιλλέας",  '15-05-2020'));
		nameDays.add(new NameDay("Ηλίας",     '20-07-2020'));
		nameDays.add(new NameDay("Ιωσήφ",     '31-07-2020'));
		nameDays.add(new NameDay("Αλέξης",    '30-08-2020'));
		nameDays.add(new NameDay("Θωμάς",     '06-10-2020'));
		nameDays.add(new NameDay("Άγγελος",   '08-11-2020'));
		nameDays.add(new NameDay("Γρηγόρης",  '14-11-2020'));
		nameDays.add(new NameDay("Νικόλαος",  '06-12-2020'));

		
	}
}

class RandomWordsState extends State<RandomWords> {
	final List<NameDay> nameDays = (new NameDays()).nameDays;
	final Set<NameDay> selectedNameDays = Set<NameDay>();
	final _biggerFont = const TextStyle(fontSize: 18.0);
	String calendarID;

	RandomWordsState() {
		CalendarPlugin deviceCalendarPlugin = new CalendarPlugin();

		deviceCalendarPlugin.getCalendars().then((calendars) => 
			calendarID = calendars.getRange(0, 1).toList()[0].id
		);
	}

  	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
			title: Text('Startup Name Generator'),
			actions: <Widget>[      // Add 3 lines from here...
				IconButton(icon: Icon(Icons.list), onPressed: _pushSaved),
			],
			),
			body: _buildSuggestions(),
		);
	}

	void _pushSaved() {
	Navigator.of(context).push(
		MaterialPageRoute<void>(
		builder: (BuildContext context) {
			final Iterable<ListTile> tiles = selectedNameDays.map(
				(NameDay pair) {
					return ListTile(
					title: Text(
						pair.name,
						style: _biggerFont,
					),
					trailing: Text(
						pair.date
					),
					);
				},
			);
			final List<Widget> divided = ListTile
			.divideTiles(
				context: context,
				tiles: tiles,
			)
				.toList();

			return Scaffold(
				appBar: AppBar(
					title: Text('Επιλεγμένες εορτές'),
				),
				// body: ListView(children: divided),
				body: Column(
					children:[
						
						Expanded(
							child: ListView(children: divided)
						),
						SizedBox(height: 10),
						FlatButton(
	  						shape: new RoundedRectangleBorder(
								borderRadius: new BorderRadius.circular(18.0),

							// fill in required params
							),
							color: Colors.blue,
							textColor: Colors.white,
							padding: EdgeInsets.all(16.0),
							
							onPressed: () => {
								addNamedaysToCalendar()
							},

							child: Text(
								'Προσθήκη στο ημερολόγιο',
								style: TextStyle(fontSize: 20)
							),	
						),
						SizedBox(height: 10),
					])
			);                       // ... to here.
		},
		),
	);
	}

	Widget _buildSuggestions() {
		return ListView.builder(
			padding: const EdgeInsets.all(1.0),
			itemCount: nameDays.length,
				itemBuilder: (BuildContext ctxt, int index) {
				return _buildRow(nameDays[index]);
				}
			);
	}

	Widget _buildRow(NameDay pair) {
		final bool alreadySaved = selectedNameDays.contains(pair);

		return ListTile(
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

	addNamedaysToCalendar() {
		CalendarPlugin deviceCalendarPlugin = new CalendarPlugin();
	
		String calendarID = "2";

		deviceCalendarPlugin.getCalendars().then((calendars) => {
			calendarID = calendars.getRange(0, 1).toList()[0].id
		});

		print("CALENDAR ID " + calendarID);
		calendarID = "2";


		// RetrieveEventsParams retrieveEventsParams = new RetrieveEventsParams(startDate: new DateTime(new DateTime.now().year, 1, 1), endDate: new DateTime(new DateTime.now().year + 1, 12, 31));

		deviceCalendarPlugin.getEvents(calendarId:"2").then((val) {
			val.forEach((event) {
				if (event.title.contains("🎂 Ονομαστική Εορτή: ")) {
					print("CONTAINSSSSSSS " + event.eventId);
					deviceCalendarPlugin.deleteEvent(calendarId: calendarID, eventId: event.eventId).then((val) {
						print(val);
						print("DELETED");
						// print(val.errorMessages);
					});
				}
			});
			// deleteEvent(String calendarId, String eventId)
		});

		CalendarEvent event = new CalendarEvent();
		
		selectedNameDays.forEach((nameday) {
			// event = calendarID;
			event.title = "🎂 Ονομαστική Εορτή: " + nameday.name + " 🎂";
			event.description = "Σήμερα γιορτάζει ο " + nameday.name + ". Ευχηθείτε του Xρόνια Πολλά.";

			int year = int.parse(nameday.date.split("-")[2]);
			int month = int.parse(nameday.date.split("-")[1]);
			int day = int.parse(nameday.date.split("-")[0]);

			event.startDate = new DateTime(year, month, day);
			event.endDate = new DateTime(year, month, day + 1);
			
			event.isAllDay = true;
			
			deviceCalendarPlugin.createEvent(calendarId: "2", event: event);
		});
	}
}

class RandomWords extends StatefulWidget {
  @override
  RandomWordsState createState() => RandomWordsState();
}