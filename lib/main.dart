import 'package:flutter/material.dart';
import 'package:manage_calendar_events/manage_calendar_events.dart';
import 'nameday.dart';
import 'SelectionScreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
	@override
	Widget build(BuildContext context) {
		return MaterialApp(
			title: 'Εορτολόγιο',
			home: SavedNamedays(),
		);
	}
}

class SavedNamedaysState extends State<SavedNamedays> {
	NameDays nameDays = new NameDays(true);
	NameDays savedNamedays = new NameDays(false);
	NameDays selectedNameDays = new NameDays(false);
	final _biggerFont = const TextStyle(fontSize: 18.0);
	String calendarID;

	@override
	void initState() {
		super.initState();

		loadSavedNamedays();
	}

  	@override
	Widget build(BuildContext context) {
		if(calendarID == null && savedNamedays == null) {
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
			floatingActionButton: loadFloatingActionButtons(),
		);
	}

	Widget loadFloatingActionButtons() {
		if (calendarID == null) return null;

		return Stack(
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
							visible: selectedNameDays.nameDaysList.length > 0,
						)
					),
				),

				Align(
					alignment: Alignment.bottomRight,
					child: FloatingActionButton(
						onPressed: (() {
							setState(() {
								selectedNameDays.nameDaysList.clear();
							});
							
							Navigator.push(
								context,
								MaterialPageRoute(
									builder: (context) => SelectionScreen(calendarID: calendarID, selectedNameDays: savedNamedays,
								),
							)).then((val) => loadSavedNamedays());
						}),
					child: Icon(Icons.add), tooltip: 'Προσθήκη Εορτών'),
				),
			],
		);
	}

	Widget loadNamedays() {
		return ListView.builder(
			padding: const EdgeInsets.all(1.0),
			itemCount: calendarID != null && calendarID.isEmpty ? nameDays.nameDaysList.length : savedNamedays.nameDaysList.length,
			itemBuilder: (BuildContext ctxt, int index) {
				return loadNameday(calendarID != null && calendarID.isEmpty ? nameDays.nameDaysList[index] : savedNamedays.nameDaysList[index]);
			}
		);
	}

	Widget loadNameday(NameDay pair) {
		final bool alreadySaved = selectedNameDays != null ? selectedNameDays.nameDaysList.contains(pair) : false;

		if (pair.hypocorisms.isNotEmpty) {
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
					onLongPress: calendarID.isEmpty ? null : () {
						setState(() {
							alreadySaved ? selectedNameDays.nameDaysList.remove(pair) : selectedNameDays.nameDaysList.add(pair);
						});
					},

					onTap: calendarID.isEmpty || selectedNameDays.nameDaysList.length == 0 ? null : () {
						setState(() {
							alreadySaved ? selectedNameDays.nameDaysList.remove(pair) : selectedNameDays.nameDaysList.add(pair);
						});
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
					onLongPress: calendarID.isEmpty ? null : () {
						setState(() {
							alreadySaved ? selectedNameDays.nameDaysList.remove(pair) : selectedNameDays.nameDaysList.add(pair);
						});
					},

					onTap: calendarID.isEmpty || selectedNameDays.nameDaysList.length == 0 ? null : () {
						setState(() {
							alreadySaved ? selectedNameDays.nameDaysList.remove(pair) : selectedNameDays.nameDaysList.add(pair);
						});
					},
				),
				color: (alreadySaved != true ? Colors.white : Colors.grey),
			);
		}
	}

	void noCalendarAvailableDialog(BuildContext context) {
		showDialog<bool>(
			context: context,
			builder: (context) {
				return AlertDialog(
					title: Text('Μη Διαθέσιμο Ημερολόγιο', textAlign: TextAlign.center),
					titleTextStyle: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 20),
					
					content: SingleChildScrollView(
						child: ListBody(
							children: <Widget>[
								Icon(Icons.warning),
								Text('\nΔεν είστε συνδεδεμένος στο Google Calendar.'),
							],
						),
					),
					actions: <Widget>[
						FlatButton(
							child: const Text('OK'),
							onPressed: () {
								Navigator.of(context).pop(true);
							},
						),
					],
				);
			},
		);
	}

	void loadSavedNamedays() {
		CalendarPlugin calendarAPI = new CalendarPlugin();

		savedNamedays.nameDaysList.clear();

		calendarAPI.getCalendars().then((calendars) { 
			calendars.forEach((val) {
				if (val.name.contains("@gmail.com")) calendarID = val.id;
			});

			if(calendarID == null) {
				setState(() {
					calendarID = ""; 
					noCalendarAvailableDialog(context);
				
				});

				return;
			}

			calendarAPI.getEvents(calendarId:calendarID).then((val) {
				setState(() {
					val.forEach((event) {
						if (event.title.contains("🎂 Ονομαστική Εορτή: ") && event.startDate.year == new DateTime.now().year) {
							String name = event.title.split(" ")[event.title.split(" ").length - 1];
							String date = (event.startDate.day < 10? "0" : "") + event.startDate.day.toString() + "-" + (event.startDate.month < 10? "0" : "") + event.startDate.month.toString() + "-" + event.startDate.year.toString();

							savedNamedays.nameDaysList.add(new NameDay(name: name, date: date, eventID: event.eventId));
						}
					});

					savedNamedays.sort();
				});
			});
		});
	}

	void deleteNamedayEvents() {
		CalendarPlugin calendarAPI = new CalendarPlugin();

		selectedNameDays.nameDaysList.forEach((nameday) {
			calendarAPI.deleteEvent(calendarId: calendarID, eventId: nameday.eventID);
			savedNamedays.nameDaysList.remove(nameday);
		});

		selectedNameDays.nameDaysList.clear();
	}
}

class SavedNamedays extends StatefulWidget {
	@override
	State createState() => SavedNamedaysState();
}