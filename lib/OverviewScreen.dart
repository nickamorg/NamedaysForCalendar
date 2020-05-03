import 'package:flutter/material.dart';
import 'package:manage_calendar_events/manage_calendar_events.dart';
import 'nameday.dart';

class OverviewScreen extends StatelessWidget {
	final NameDays selectedNameDays;
	final String calendarID;

	OverviewScreen({Key key, @required this.calendarID, @required this.selectedNameDays}) : super(key: key) {
		selectedNameDays.sort();
	}

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
				title: Text("Επιλεγμένες Eορτές"),
			),
			body: Column(
				children:[
					Expanded(
						child: ListView(children: selectedNameDays.nameDaysList.where((nameday) => nameday.eventID == null).map(
							(NameDay pair) {
								return ListTile(
									title: Text(
										pair.name,
									),
									trailing: Text(
										pair.date
									),
								);
							}).toList()
						)
					),
					SizedBox(height: 10),
					FlatButton(
						shape: new RoundedRectangleBorder(
							borderRadius: new BorderRadius.circular(18.0),
						),
						color: Colors.blue,
						textColor: Colors.white,
						padding: EdgeInsets.all(16.0),
						
						onPressed: () {
							addNamedaysToCalendar();
							calendarSyncDialog(context);
						},

						child: Text(
							'Προσθήκη στο Ημερολόγιο',
							style: TextStyle(fontSize: 20)
						),	
					),
					SizedBox(height: 10),
				]
			)
		);
	}

	addNamedaysToCalendar() {
		CalendarPlugin calendarAPI = new CalendarPlugin();

		CalendarEvent event = new CalendarEvent();
		
		selectedNameDays.nameDaysList.forEach((nameday) {
			event.title = "🎂 Ονομαστική Εορτή: " + nameday.name;
			event.description = "Σήμερα γιορτάζει ο " + nameday.name + ". Ευχηθείτε του Xρόνια Πολλά.";

			int year = int.parse(nameday.date.split("-")[2]);
			int month = int.parse(nameday.date.split("-")[1]);
			int day = int.parse(nameday.date.split("-")[0]);

			event.startDate = new DateTime(year, month, day, 0, 0, 0);
			event.endDate = new DateTime(year, month, day, 0, 0, 0);
			event.isAllDay = true;
			
			calendarAPI.createEvent(calendarId: calendarID, event: event);
		});
	}

	void calendarSyncDialog(BuildContext context) {
		showDialog<bool>(
			context: context,
			builder: (BuildContext context) {
				return AlertDialog(
					title: Text('Επιτυχής Αποθήκευση', textAlign: TextAlign.center),
					titleTextStyle: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 20),
					
					content: SingleChildScrollView(
						child: ListBody(
							children: <Widget>[
								Text('Οι επιλεγμένες εορτές προστέθηκαν ως γεγονότα στο ημερολόγιο.'),
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
}