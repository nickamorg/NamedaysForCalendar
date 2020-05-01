import 'package:flutter/material.dart';
import 'package:manage_calendar_events/manage_calendar_events.dart';
import 'nameday.dart';

class DetailScreen extends StatelessWidget {
	final List<NameDay> selectedNameDays;
	final String calendarID;

	DetailScreen({Key key, @required this.calendarID, @required this.selectedNameDays}) : super(key: key);

	@override
	Widget build(BuildContext context) {
		// Use the Todo to create the UI.
		return Scaffold(
		appBar: AppBar(
			title: Text("Επιλεγμένες Eορτές"),
		),
			body: Column(
				children:[
					Expanded(
						child: ListView(children: selectedNameDays.map(
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

						// fill in required params
						),
						color: Colors.blue,
						textColor: Colors.white,
						padding: EdgeInsets.all(16.0),
						
						onPressed: () => {
							addNamedaysToCalendar()
						},

						child: Text(
							'Συγχρονισμός Ημερολογίου',
							style: TextStyle(fontSize: 20)
						),	
					),
					SizedBox(height: 10),
				])
		);
	}

	addNamedaysToCalendar() {
		print("Lala");
		CalendarPlugin deviceCalendarPlugin = new CalendarPlugin();

		deviceCalendarPlugin.getEvents(calendarId:calendarID).then((val) {
			val.forEach((event) {
				if (event.title.contains("🎂 Ονομαστική Εορτή: ")) {
					print("TO BE DELETED");
					deviceCalendarPlugin.deleteEvent(calendarId: calendarID, eventId: event.eventId);
				}
			});
		});

		CalendarEvent event = new CalendarEvent();
		
		print("SIZE  " + selectedNameDays.length.toString());
		selectedNameDays.forEach((nameday) {
			event.title = "🎂 Ονομαστική Εορτή: " + nameday.name;
			event.description = "Σήμερα γιορτάζει ο " + nameday.name + ". Ευχηθείτε του Xρόνια Πολλά.";

			int year = int.parse(nameday.date.split("-")[2]);
			int month = int.parse(nameday.date.split("-")[1]);
			int day = int.parse(nameday.date.split("-")[0]);

			print(year.toString() + " " + month.toString() + " " + day.toString());

			event.startDate = new DateTime(year, month, day, 0, 0, 0);
			event.endDate = new DateTime(year, month, day, 0, 0, 0);
			
			event.isAllDay = true;
			
			deviceCalendarPlugin.createEvent(calendarId: calendarID, event: event).then((val) {
				print(val);
			});
		});
	}

}