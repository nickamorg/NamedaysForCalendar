import 'package:flutter/material.dart';
import 'package:device_calendar/device_calendar.dart';
import 'SelectionScreen.dart';
import 'NameDay.dart';

void main() => runApp(MyApp());

enum Permission {
	NON_GRANTED, REGECTED, GRANTED
}

class MyApp extends StatelessWidget {
	
	@override
	Widget build(BuildContext context) {
		return MaterialApp(
			title: 'Εορτολόγιο',
			home: SavedNameDays(),
		);
	}
}

class SavedNameDaysState extends State<SavedNameDays> {
	final DeviceCalendarPlugin calendarAPI = new DeviceCalendarPlugin();
    final _biggerFont = const TextStyle(fontSize: 18.0);
	List<NameDay> savedNameDays = new List<NameDay>();
	List<NameDay> selectedNameDays = new List<NameDay>();
	Permission calendarPermission = Permission.NON_GRANTED;
	String calendarID;

	@override
	void initState() {
		super.initState();

        NameDays();

		loadSavedNameDays();
	}

  	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
				title: Text(calendarPermission != Permission.GRANTED ? 'Εορτολόγιο' : 'Αποθηκευμένες Εορτές'),
			),
			body: loadNameDays(),
			floatingActionButton: loadFloatingActionButtons(),
		);
	}

	Widget loadFloatingActionButtons() {
		if (calendarPermission == Permission.NON_GRANTED) return null;

		if (calendarPermission == Permission.REGECTED) {
			return FloatingActionButton(
				onPressed: () {
					new DeviceCalendarPlugin().requestPermissions().then((val) {
						if(val.data != null && val.data) {
							readCalendarEvents();
						}
					});
				},
				tooltip: 'Άδεια Χρήσης Ημερολογίου',
				child: Icon(Icons.perm_contact_calendar),
				backgroundColor: Colors.blue,
			);
		}

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
										deleteNameDayEvents();
									});
								},
                                tooltip: 'Διαγραφή Επιλεγμένων Εορτών',
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
									builder: (context) => SelectionScreen(calendarID: calendarID, selectedNameDays: savedNameDays,
								),
							)).then((val) => loadSavedNameDays());
						}),
					    child: Icon(Icons.add),
                        tooltip: 'Προσθήκη Εορτών'
                    ),
				),
			],
		);
	}

	Widget loadNameDays() {
		return ListView.builder(
			padding: const EdgeInsets.all(1.0),
			itemCount: calendarPermission != Permission.GRANTED ? NameDays.nameDaysList.length : savedNameDays.length,
			itemBuilder: (BuildContext ctxt, int index) {
				return loadNameDay(calendarPermission != Permission.GRANTED ? NameDays.nameDaysList[index] : savedNameDays[index]);
			}
		);
	}

	Widget loadNameDay(NameDay pair) {
		final bool alreadySaved = selectedNameDays != null ? selectedNameDays.contains(pair) : false;

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
					onLongPress: calendarPermission != Permission.GRANTED ? null : () {
						setState(() {
							alreadySaved ? selectedNameDays.remove(pair) : selectedNameDays.add(pair);
						});
					},
					onTap: calendarPermission != Permission.GRANTED || selectedNameDays.length == 0 ? null : () {
						setState(() {
							alreadySaved ? selectedNameDays.remove(pair) : selectedNameDays.add(pair);
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
					onLongPress: calendarPermission != Permission.GRANTED ? null : () {
						setState(() {
							alreadySaved ? selectedNameDays.remove(pair) : selectedNameDays.add(pair);
						});
					},
					onTap: calendarPermission != Permission.GRANTED || selectedNameDays.length == 0 ? null : () {
						setState(() {
							alreadySaved ? selectedNameDays.remove(pair) : selectedNameDays.add(pair);
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

	void loadSavedNameDays() {
		DeviceCalendarPlugin calendarPlugin = new DeviceCalendarPlugin();

		savedNameDays.clear();

		calendarPlugin.hasPermissions().then((val) {
			if(val.data) {
				readCalendarEvents();
			} else {
				calendarPlugin.requestPermissions().then((val) {
					if(val.data != null && val.data) {
						readCalendarEvents();
					} else {
						setState(() { calendarPermission = Permission.REGECTED; });
					}

				});
			}
		});

	}

	void deleteNameDayEvents() {
		selectedNameDays.forEach((nameDay) {
			new DeviceCalendarPlugin().deleteEvent(calendarID, nameDay.eventID);
			savedNameDays.remove(nameDay);
		});

		selectedNameDays.clear();
	}

	void readCalendarEvents() {
		new DeviceCalendarPlugin().retrieveCalendars().then((calendars) { 
			calendars.data.forEach((val) {
				if (val.name.contains('@gmail.com')) {
					calendarPermission = Permission.GRANTED;
					calendarID = val.id;
				}
			});

			if (calendarID == null) {
				setState(() {
					noCalendarAvailableDialog(context);
				});

				return;
			}
			
			int year = new DateTime.now().year;
			RetrieveEventsParams retrieveEventsParams = new RetrieveEventsParams(startDate: new DateTime(year), endDate:  new DateTime(year, 12, 31));
			calendarAPI.retrieveEvents(calendarID, retrieveEventsParams).then((val) {
				setState(() {
					val.data.forEach((event) {
						if (event.title.contains('🎂 Ονομαστική Εορτή: ') && event.start.year == new DateTime.now().year) {
							String name = event.title.split(' ')[event.title.split(' ').length - 1];
							String date = (event.start.day < 10 ? '0' : '') + event.end.day.toString() + '-' + (event.start.month < 10 ? '0' : '') + event.start.month.toString() + '-' + event.start.year.toString();

							savedNameDays.add(new NameDay(name: name, date: date, eventID: event.eventId));
						}
					});

					savedNameDays.sort((a, b) => a.name.compareTo(b.name));
				});
			});
		});
	}
}

class SavedNameDays extends StatefulWidget {
    
	@override
	State createState() => SavedNameDaysState();
}