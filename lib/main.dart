// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
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

			print("Calendar ID   " + calendarID);

			new CalendarPlugin().getEvents(calendarId:calendarID).then((val) {

				setState(() {
					selectedNameDays = new List<NameDay>();
					val.forEach((event) {
						if (event.title.contains("🎂 Ονομαστική Εορτή: ")) {
							String name = event.title.split(" ")[event.title.split(" ").length - 1];
							String date = (event.startDate.day < 10? "0" : "") + event.startDate.day.toString() + "-" + (event.startDate.month < 10? "0" : "") + event.startDate.month.toString() + "-" + event.startDate.year.toString();
							print("Εορτάζων: " + name);
							selectedNameDays.add(new NameDay(name, date));
							print(selectedNameDays[0].name + "  " + selectedNameDays[0].date);
						} else {
							print("other event");
						}
					});
				});
			});
		});
	}

  	@override
	Widget build(BuildContext context) {
		if(selectedNameDays == null) {
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
				actions: <Widget>[      // Add 3 lines from here...
					IconButton(icon: Icon(Icons.add), onPressed: _pushSaved),
				],
			),
			body: _buildSuggestions(),
		);
	}

	void _pushSaved() {
		Navigator.push(
			context,
			MaterialPageRoute(
				builder: (context) => DetailScreen(calendarID: calendarID, selectedNameDays: selectedNameDays,
			),
        ));
		
	
	}

	Widget _buildSuggestions() {
		return ListView.builder(
			padding: const EdgeInsets.all(1.0),
			itemCount: nameDays.nameDaysList.length,
				itemBuilder: (BuildContext ctxt, int index) {
					return _buildRow(nameDays.nameDaysList[index]);
				}
			);
	}

	Widget _buildRow(NameDay pair) {
		print("Build row");
		final bool alreadySaved = selectedNameDays != null ? selectedNameDays.contains(pair) : false;

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
}

class RandomWords extends StatefulWidget {
	@override
	State createState() => RandomWordsState();
}