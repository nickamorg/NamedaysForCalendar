import 'package:flutter/material.dart';
import 'package:manage_calendar_events/manage_calendar_events.dart';
import 'nameday.dart';

class OverviewScreen extends StatelessWidget {
	final List<NameDay> selectedNameDays;
	final String calendarID;

	OverviewScreen({Key key, @required this.calendarID, @required this.selectedNameDays}) : super(key: key) {
		selectedNameDays.sort((a, b) => a.name.compareTo(b.name));
	}

    @override
	Widget build(BuildContext context) {
		return OverviewNamedays(calendarID: calendarID, selectedNameDays: selectedNameDays);
	}

}

class OverviewNamedaysState extends State<OverviewNamedays> {
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
				title: Text("Επιλεγμένες Eορτές (" + selectedNameDays.where((nameday) => nameday.eventID == null).length.toString() + ")"),
			),
			body: Column(
				children:[
					Expanded(
						child: ListView(children: selectedNameDays.where((nameday) => nameday.eventID == null).map(
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
							addNamedaysToCalendar();
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

	void addNamedaysToCalendar() {
		selectedNameDays.forEach((nameday) {
            if (nameday.eventID != null) return;

			event.title = "🎂 Ονομαστική Εορτή: " + nameday.name;
			event.description = "Σήμερα γιορτάζει ο " + nameday.name + ". Ευχηθείτε του Xρόνια Πολλά.";

			int year = int.parse(nameday.date.split("-")[2]);
			int month = int.parse(nameday.date.split("-")[1]);
			int day = int.parse(nameday.date.split("-")[0]);

			event.startDate = new DateTime(year, month, day, 0, 0, 0);
			event.endDate = new DateTime(year, month, day, 0, 0, 0);
			event.isAllDay = true;
			
			new CalendarPlugin().createEvent(calendarId: calendarID, event: event).then((eventID) => nameday.eventID = eventID);
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

class OverviewNamedays extends StatefulWidget {
	final List<NameDay> selectedNameDays;
	final String calendarID;

	OverviewNamedays({Key key, this.calendarID, this.selectedNameDays}) : super(key: key);

	@override
	State createState() => OverviewNamedaysState();
}