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
	final DeviceCalendarPlugin calendarAPI = DeviceCalendarPlugin();
    final fontSize18 = const TextStyle(fontSize: 18);
	List<NameDay> savedNameDays = List<NameDay>();
	List<NameDay> selectedNameDays = List<NameDay>();
	Permission calendarPermission = Permission.NON_GRANTED;
	String calendarID;
	String displayedHypocorisms;

	@override
	void initState() {
		super.initState();

		displayedHypocorisms = null;
        NameDays();
		loadSavedNameDays();
	}

  	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
				title: Text(calendarPermission != Permission.GRANTED ? 'Εορτολόγιο' : 'Αποθηκευμένες Εορτές')
			),
			body: savedNameDays.length == 0 && calendarPermission != Permission.REGECTED?
			Center(
				child: Container(
					padding: const EdgeInsets.all(20),
					child: Text(
						"Δεν βρέθηκε καμία αποθηκευμένη εορτή στο ημερολόγιο",
						style: fontSize18,
						textAlign: TextAlign.center
					)
				)
			)
			:
			Stack(
				alignment: Alignment.center,
				children: [
					loadNameDays(),
					displayedHypocorisms != null ?
					Positioned(
						top: 5,
						child: Card(
							child: Container(
								alignment: Alignment.center,
								height: 100,
								padding: const EdgeInsets.all(20),
								width: MediaQuery.of(context).size.width - 40,
								child: Text(displayedHypocorisms, textAlign: TextAlign.center)
							)
						)
					)
					:
					SizedBox.shrink()
				]
			),
			floatingActionButton: loadFloatingActionButtons()
		);
	}

	Widget loadFloatingActionButtons() {
		if (calendarPermission == Permission.NON_GRANTED) return null;

		if (calendarPermission == Permission.REGECTED) {
			return Tooltip(
				message: "Άδεια Χρήσης Ημερολογίου",
				padding: const EdgeInsets.all(10),
				margin: const EdgeInsets.only(bottom: 10),
				child: FloatingActionButton(
					onPressed: () {
						DeviceCalendarPlugin().requestPermissions().then((val) {
							if (val.data != null && val.data) {
								readCalendarEvents();
							}
						});
					},
					child: Icon(Icons.perm_contact_calendar),
					backgroundColor: Colors.blue
				)
			);
		}

		return Stack(
			children: [
				Padding(
					padding: EdgeInsets.only(left:31),
					child: Align(
						alignment: Alignment.bottomLeft,
						child: AnimatedOpacity(
							opacity: selectedNameDays.length > 0 ? 1 : 0,
							duration: Duration(milliseconds: 500),
							child: Tooltip(
								message: "Διαγραφή Επιλεγμένων Εορτών",
								padding: const EdgeInsets.all(10),
								margin: const EdgeInsets.only(bottom: 10),
								child: FloatingActionButton(
									heroTag: "deleteNameDays",
									backgroundColor: Colors.red,
									onPressed: selectedNameDays.length == 0 ? null : () {
										setState(() {
											deleteNameDayEvents();
										});
									},
									child: Icon(Icons.delete)
								)
							)
						)
					)
				),
				Align(
					alignment: Alignment.bottomRight,
					child: AnimatedOpacity(
						opacity: selectedNameDays.length == 0 ? 1 : 0,
						duration: Duration(milliseconds: 500),
						child: Tooltip(
							message: "Προσθήκη Εορτών",
							padding: const EdgeInsets.all(10),
							margin: const EdgeInsets.only(bottom: 10),
							child: FloatingActionButton(
								heroTag: "addNameDays",
								onPressed: selectedNameDays.length > 0 ? null : (() {
									setState(() {
										selectedNameDays.clear();
									});

									Navigator.push(
										context,
										MaterialPageRoute(
											builder: (context) => SelectionScreen(calendarID: calendarID, selectedNameDays: savedNameDays
										),
									)).then((val) => loadSavedNameDays());
								}),
								child: Icon(Icons.add)
							)
						)
					)
				)
			]
		);
	}

	Widget loadNameDays() {
		return ListView.builder(
			padding: const EdgeInsets.all(1),
			itemCount: calendarPermission != Permission.GRANTED ? NameDays.nameDaysList.length : savedNameDays.length,
			itemBuilder: (BuildContext ctxt, int index) {
				return loadNameDay(calendarPermission != Permission.GRANTED ? NameDays.nameDaysList[index] : savedNameDays[index]);
			}
		);
	}

	Widget loadNameDay(NameDay pair) {
		final bool alreadySaved = selectedNameDays != null ? selectedNameDays.contains(pair) : false;

		return GestureDetector(
			child: Container(
				color: (alreadySaved != true ? Colors.white : Colors.grey),
				child: ListTile(
					title: Text(pair.name),
					trailing: Text(pair.date),
					onLongPress: calendarPermission != Permission.GRANTED ? null : () {
						setState(() {
							alreadySaved ? selectedNameDays.remove(pair) : selectedNameDays.add(pair);
						});
					},
					onTap: calendarPermission != Permission.GRANTED || selectedNameDays.length == 0 ? null : () {
						setState(() {
							alreadySaved ? selectedNameDays.remove(pair) : selectedNameDays.add(pair);
						});
					}
				)
			),
			onLongPress: pair.hypocorisms.isEmpty ? null : () {
				displayedHypocorisms = pair.hypocorisms;
				setState(() { });
			},
			onLongPressUp: pair.hypocorisms.isEmpty ? null : () {
				displayedHypocorisms = null;
				setState(() { });
			}
		);
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
								Text('\nΔεν είστε συνδεδεμένος στο Google Calendar.')
							]
						)
					),
					actions: <Widget>[
						FlatButton(
							child: const Text('OK'),
							onPressed: () {
								Navigator.of(context).pop(true);
							}
						)
					]
				);
			}
		);
	}

	void loadSavedNameDays() {
		savedNameDays.clear();

		calendarAPI.hasPermissions().then((val) {
			if (val.data) {
				readCalendarEvents();
			} else {
				calendarAPI.requestPermissions().then((val) {
					if (val.data != null && val.data) {
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
			calendarAPI.deleteEvent(calendarID, nameDay.eventID);
			savedNameDays.remove(nameDay);
		});

		selectedNameDays.clear();
	}

	void readCalendarEvents() {
		calendarAPI.retrieveCalendars().then((calendars) { 
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

			int year = DateTime.now().year;
			RetrieveEventsParams retrieveEventsParams = RetrieveEventsParams(startDate: DateTime(year), endDate:  DateTime(year, 12, 31));

			calendarAPI.retrieveEvents(calendarID, retrieveEventsParams).then((val) {
				setState(() {
					val.data.forEach((event) {
						if (event.title.contains('🎂 Ονομαστική Εορτή: ') && event.start.year == DateTime.now().year) {
							String name = event.title.split(' ')[event.title.split(' ').length - 1];
							String date = (event.start.day < 10 ? '0' : '') + event.end.day.toString() + '-' + (event.start.month < 10 ? '0' : '') + event.start.month.toString() + '-' + event.start.year.toString();

							savedNameDays.add(NameDay(name: name, date: date, eventID: event.eventId));
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