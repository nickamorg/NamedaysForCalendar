import 'package:flutter/material.dart';
import 'package:device_calendar/device_calendar.dart';
import 'main.dart';
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
    List<NameDay> selectedNameDays;
	String calendarID;
	Event event;
    bool areSaved = false;
    bool isButtonLocked = false;
	String displayedHypocorisms;

	@override
  	void initState() {
    	super.initState();

		displayedHypocorisms = null;
	}

    @override
	Widget build(BuildContext context) {
        selectedNameDays = widget.selectedNameDays;
		calendarID = widget.calendarID;
		event = Event(calendarID);
        int selectedNameDaysCount = selectedNameDays.where((nameDay) => nameDay.eventID == null).length;

		return Scaffold(
			appBar: AppBar(
				title: Text('Επιλεγμένες Eορτές' + (selectedNameDaysCount > 0 ? (' (' + selectedNameDaysCount.toString() + ')') : '')),
			),
			body: Stack(
                alignment: Alignment.center,
                children: [
                    Column(
                        children:[
                            Expanded(
                                child: ListView(children: selectedNameDays.where((nameDay) => nameDay.eventID == null).map(
                                    (NameDay pair) {
                                        return GestureDetector(
                                            child: ListTile(
                                                title: Text(pair.name),
                                                trailing: Text(pair.date)
                                            ),
                                            onLongPress: pair.hypocorisms.isEmpty ? null :() {
                                                displayedHypocorisms = pair.hypocorisms;
                                                setState(() { });
                                            },
                                            onLongPressUp: pair.hypocorisms.isEmpty ? null :() {
                                                displayedHypocorisms = null;
                                                setState(() { });
                                            }
                                        );
                                    }).toList()
                                )
                            ),
                            SizedBox(height: 10),
                            areSaved ? Container(
                                width: 150,
                                height: 50,
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                        Icon(Icons.check, color: Colors.white),
                                        Text("Προστέθηκαν", style: TextStyle(color: Colors.white))
                                    ]
                                ),
                                decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.all(Radius.circular(50))
                                )
                            )
                            :
                            isButtonLocked ? Center(
                                child: Container(
                                    height: 50,
                                    width: 50,
                                    child: CircularProgressIndicator(
                                        valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                                        strokeWidth: 10
                                    )
                                )
                            )
                            :
                            FlatButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18)
                                ),
                                color: Colors.blue,
                                textColor: Colors.white,
                                padding: EdgeInsets.all(16),
                                onPressed: areSaved ? null : () {
                                    setState(() {
                                        isButtonLocked = true;
                                    });
                                    addNameDaysToCalendar();
                                },
                                child: Text('Προσθήκη στο Ημερολόγιο', style: TextStyle(fontSize: 18))
                            ),
                            SizedBox(height: 10)
                        ]
                    ),
                    displayedHypocorisms != null ?
                    Positioned(
                        bottom: 5,
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
            )
		);
	}

	void addNameDaysToCalendar() {
        int counter = selectedNameDays.where((nameDay) => nameDay.eventID == null).length;
        
		selectedNameDays.forEach((nameDay) {
            if (nameDay.eventID != null) return;

			event.title = '🎂 Ονομαστική Εορτή: ${nameDay.name}';
			event.description = 'Επίσης γιορτάζουν οι: ${nameDay.hypocorisms}';

			int year = int.parse(nameDay.date.split('-')[2]);
			int month = int.parse(nameDay.date.split('-')[1]);
			int day = int.parse(nameDay.date.split('-')[0]);

			event.start = DateTime(year, month, day, 0, 0, 0);
			event.end = DateTime(year, month, day, 0, 0, 0);
			event.allDay = true;
            event.reminders = null;
            event.attendees = null;
            event.location = null;
            event.recurrenceRule = null;
            event.url = null;

			DeviceCalendarPlugin().createOrUpdateEvent(event).then((response) {
                counter--;

                if (response.errorMessages.isNotEmpty) {
                    areSaved = false;
                } else {
                    nameDay.eventID = response.data;

                    if (counter == 0) {
                        setState(() {
                          areSaved = true;
                        });
                    }
                }
                
                if (counter == 0) {
                    calendarSyncDialog();
                }
            });
		});
    }

	void calendarSyncDialog() {
		showDialog<bool>(
            barrierDismissible: false,
			context: context,
			builder: (BuildContext context) {
				return AlertDialog(
					title: Text((areSaved ? 'Επιτυχής' : 'Ανεπιτυχής') + ' Προσθήκη', textAlign: TextAlign.center),
					titleTextStyle: TextStyle(color: areSaved ? Colors.blue : Colors.red, fontWeight: FontWeight.bold, fontSize: 20),
					content: SingleChildScrollView(
						child: ListBody(
							children: <Widget>[
								Text(areSaved ? 'Οι επιλεγμένες εορτές προστέθηκαν ως γεγονότα στο ημερολόγιο.' : 'Υπήρξε κάποιο πρόβλημα, οι εορτές δεν προστέθηκαν στο ημερολόγιο'),
							]
						)
					),
					actions: <Widget>[
						FlatButton(
							child: Text('OK', style: TextStyle(color: areSaved ? Colors.blue : Colors.red)),
							onPressed: () {
								Navigator.of(context).pop(true);

                                if (areSaved) {
                                    Navigator.of(context).pop(true);
                                    Navigator.of(context).pop(true);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => MyApp()
                                        )
                                    );
                                }
							}
						)
					]
				);
			}
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