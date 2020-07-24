import 'package:flutter/material.dart';
import 'OverviewScreen.dart';
import 'NameDay.dart';

class SelectionScreen extends StatelessWidget {
	final List<NameDay> selectedNameDays;
	final String calendarID;

  	SelectionScreen({Key key, @required this.calendarID, @required this.selectedNameDays}) : super(key: key);

	@override
	Widget build(BuildContext context) {
		return SelectNameDays(calendarID: calendarID, selectedNameDays: selectedNameDays);
	}
}

class SelectNameDaysState extends State<SelectNameDays> {
	final fontSize18 = const TextStyle(fontSize: 18);
	final searchNdayCtrl = TextEditingController();
	List<NameDay> selectedNameDays;
	int alreadySavedNameDays = -1;
	String calendarID;
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

		if (alreadySavedNameDays == -1) alreadySavedNameDays = selectedNameDays.length;

		return Scaffold(
			appBar: AppBar(
				title: Text('Επιλογή Εορτών')
			),
			body: loadListView(),
			floatingActionButton: AnimatedOpacity(
				opacity: selectedNameDays.length > alreadySavedNameDays ? 1 : 0,
				duration: Duration(milliseconds: 500),
				child: FloatingActionButton.extended(
					onPressed: selectedNameDays.length <= alreadySavedNameDays ? null : selectNameDays,
					icon: Icon(Icons.format_list_numbered),
					label: Text('Επιλογή (${selectedNameDays.length - alreadySavedNameDays})'),
					backgroundColor: Colors.blue
				)
			)
		);
	}

	void selectNameDays() {
		Navigator.push(
			context,
			MaterialPageRoute(
				builder: (context) => OverviewScreen(calendarID: calendarID, selectedNameDays: selectedNameDays)
        	)
		).then((val) => alreadySavedNameDays = selectedNameDays.where((nameDay) => nameDay.eventID != null).length);
	}

	Widget loadListView() {
		return Stack(
			alignment: Alignment.center,
			children: [
				Column(
					children:[
						Container(
							padding: const EdgeInsets.all(20),
							child: Center(
								child: TextField(
									decoration: InputDecoration(
										border: OutlineInputBorder(
											borderRadius: const BorderRadius.all(
												const Radius.circular(6),
											)
										),
										hintText: 'Αναζήτηση Ονομαστικής Εορτής'
									),
									controller: searchNdayCtrl,
									onChanged: (text) {
										setState(() {});
									},
									autofocus: true
								)
							)
						),
						Expanded(
							child: loadNameDays()
						)
					]
				),
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
		);
	}

    Widget loadNameDays() {
        int nameDaysCount = NameDays.nameDaysList.where((val) => val > searchNdayCtrl.text).length;

        return ListView.builder(
            padding: const EdgeInsets.all(1),
            itemCount: nameDaysCount,
            itemBuilder: (BuildContext ctxt, int index) {
               return loadNameDay(NameDays.nameDaysList.where((val) => val > searchNdayCtrl.text).toList(growable: true)[index]);
            }
        );
    }

	Widget loadNameDay(NameDay pair) {
		final bool alreadySelected = selectedNameDays != null ? selectedNameDays.contains(pair) : false;
		final bool alreadySaved = selectedNameDays != null ? (selectedNameDays.indexOf(pair) == -1 ? false : selectedNameDays[selectedNameDays.indexOf(pair)].eventID != null) : false;

		return GestureDetector(
			child: ListTile(
				leading: Checkbox(
					value: alreadySelected,
					onChanged: null
				),
				title: Text(pair.name),
				trailing: Text(pair.date),
				enabled: !alreadySaved,
				onTap: () {
					setState(() {
						alreadySelected ? selectedNameDays.remove(pair) : selectedNameDays.add(NameDay(name: pair.name, date: pair.date, hypocorisms: pair.hypocorisms));
					});
				}
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
}

class SelectNameDays extends StatefulWidget {
	final List<NameDay> selectedNameDays;
	final String calendarID;

	SelectNameDays({Key key, this.calendarID, this.selectedNameDays}) : super(key: key);

	@override
	State createState() => SelectNameDaysState();
}