import 'package:flutter/material.dart';
import 'package:manage_calendar_events/manage_calendar_events.dart';
import 'NameDay.dart';

class OverviewScreen extends StatelessWidget {
	final List<NameDay> selectedNameDays;
	final String calendarID;

	OverviewScreen({Key key, @required this.calendarID, @required this.selectedNameDays}) : super(key: key) {
		selectedNameDays.sort((a, b) => a.name.compareTo(b.name));
	}

    @override
	Widget build(BuildContext context) {
		return OverviewNameDays(calendarID: calendarID, selectedNameDays: selectedNameDays);
	}
}

class OverviewNameDaysState extends State<OverviewNameDays> {
    final CalendarEvent event = new CalendarEvent();
    List<NameDay> selectedNameDays;
	String calendarID;
    bool areSaved = false;
    
    @override
	Widget build(BuildContext context) {
        selectedNameDays = widget.selectedNameDays;
		calendarID = widget.calendarID;

		return Scaffold(
			appBar: AppBar(
				title: Text('Επιλεγμένες Eορτές (' + selectedNameDays.where((nameDay) => nameDay.eventID == null).length.toString() + ')'),
			),
			body: Column(
				children:[
					Expanded(
						child: ListView(children: selectedNameDays.where((nameDay) => nameDay.eventID == null).map(
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

						onPressed: areSaved ? null : () {
							addNameDaysToCalendar();
							calendarSyncDialog(context);
                            setState(() => areSaved = true );
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

	void addNameDaysToCalendar() {
		selectedNameDays.forEach((nameDay) {
            if (nameDay.eventID != null) return;

			event.title = '🎂 Ονομαστική Εορτή: ' + nameDay.name;
			event.description = 'Σήμερα γιορτάζει ο ' + nameDay.name + '. Ευχηθείτε του Xρόνια Πολλά.';

			int year = int.parse(nameDay.date.split('-')[2]);
			int month = int.parse(nameDay.date.split('-')[1]);
			int day = int.parse(nameDay.date.split('-')[0]);

			event.startDate = new DateTime(year, month, day, 0, 0, 0);
			event.endDate = new DateTime(year, month, day, 0, 0, 0);
			event.isAllDay = true;
			
			new CalendarPlugin().createEvent(calendarId: calendarID, event: event).then((eventID) => nameDay.eventID = eventID);
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

class OverviewNameDays extends StatefulWidget {
	final List<NameDay> selectedNameDays;
	final String calendarID;

	OverviewNameDays({Key key, this.calendarID, this.selectedNameDays}) : super(key: key);

	@override
	State createState() => OverviewNameDaysState();
}