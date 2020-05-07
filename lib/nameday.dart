import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';

class Normalizer {
	static List<List<String>> letters = [['ά', 'α'], ['έ', 'ε'], ['ή', 'η'], ['ί', 'ι'], ['ό', 'ο'], ['ύ', 'υ'], ['ώ', 'ω']];

	static String normalize(String str) {
		letters.forEach((letter) => str = str.replaceAll(letter[0], letter[1])); //text;

		return str;
	}
}

class NameDay {
	String name;
	String date;
	String hypocorisms;
	String eventID;

	NameDay({this.name, this.date, this.hypocorisms = "", this.eventID});

	@override
	bool operator ==(Object other) => other is NameDay && other.date == date && other.name == name;

  	int get hashCode => name.hashCode ^ name.hashCode ^ hypocorisms.hashCode;

	bool operator >(String other) {
		String substring = Normalizer.normalize(other.toLowerCase());
		String newName = Normalizer.normalize(name.toLowerCase());
		String newHypocorisms = Normalizer.normalize(hypocorisms.toLowerCase());

		return newName.startsWith(substring) || newHypocorisms.startsWith(substring) || newHypocorisms.contains(", " + substring) || date.contains(substring);
	}

     factory NameDay.fromJson(Map<String, dynamic> json) {
        return new NameDay(
            name: json['name'] as String,
            date: (json['date'] as String) + "-" + new DateTime.now().year.toString(),
            hypocorisms: json['hypocorisms'] as String,
        );
    }
}

class NameDays {
	static List<NameDay> nameDaysList;

    NameDays() {
		nameDaysList = new List<NameDay>();

        Future<String> loadAsset() async {
            return await rootBundle.loadString('assets/namedays.json');
        }

        loadAsset().then((val) {
            Map<String, dynamic> namedays = jsonDecode(val);
            namedays["namedays"].forEach((nameday) {
                nameDaysList.add(NameDay.fromJson(nameday));
            });

            nameDaysList.sort((a, b) {
                return a.name.compareTo(b.name);
            });
        });
    }

}