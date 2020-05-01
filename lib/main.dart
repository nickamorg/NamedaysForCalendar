// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
	return MaterialApp(
	  title: 'Startup Name Generator',
	  home: RandomWords(),
	);
  }
}

class NameDay {
	String name;
	String date;

	NameDay(String name, String date) {
		this.name = name;
		this.date = date;
	}
}

class NameDays {
	List<NameDay> nameDays;

	NameDays() {
		nameDays = <NameDay>[];
		nameDays.add(new NameDay("Dummy",     '29-04-2020'));
		nameDays.add(new NameDay("Dummy #2",  '30-04-2020'));
		nameDays.add(new NameDay("Dummy #3",  '30-04-2020'));
		nameDays.add(new NameDay("Βασίλειος", '01-01-2020'));
		nameDays.add(new NameDay("Σταμάτης",  '03-02-2020'));
		nameDays.add(new NameDay("Ιωάννης",   '06-03-2020'));
		nameDays.add(new NameDay("Λεωνίδας",  '15-04-2020'));
		nameDays.add(new NameDay("Ιάσονας",   '29-04-2020'));
		nameDays.add(new NameDay("Ιερεμίας",  '01-05-2020'));
		nameDays.add(new NameDay("Αχιλλέας",  '15-05-2020'));
		nameDays.add(new NameDay("Ηλίας",     '20-07-2020'));
		nameDays.add(new NameDay("Ιωσήφ",     '31-07-2020'));
		nameDays.add(new NameDay("Αλέξης",    '30-08-2020'));
		nameDays.add(new NameDay("Θωμάς",     '06-10-2020'));
		nameDays.add(new NameDay("Άγγελος",   '08-11-2020'));
		nameDays.add(new NameDay("Γρηγόρης",  '14-11-2020'));
		nameDays.add(new NameDay("Νικόλαος",  '06-12-2020'));

		
	}
}

class RandomWordsState extends State<RandomWords> {
	final List<NameDay> nameDays = (new NameDays()).nameDays;
	final _biggerFont = const TextStyle(fontSize: 18.0);
	String calendarID;

  	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
			title: Text('Startup Name Generator'),
			),
			body: _buildSuggestions(),
		);
	}

	Widget _buildSuggestions() {
		return ListView.builder(
			padding: const EdgeInsets.all(1.0),
			itemCount: nameDays.length,
				itemBuilder: (BuildContext ctxt, int index) {
				return _buildRow(nameDays[index]);
				}
			);
	}

	Widget _buildRow(NameDay pair) {

		return ListTile(
			leading: Checkbox(
				value: false,
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
				});
			},     
		);
	}
}

class RandomWords extends StatefulWidget {
  @override
  RandomWordsState createState() => RandomWordsState();
}