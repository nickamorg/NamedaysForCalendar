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

    factory NameDay.fromJsonMovable(Map<String, dynamic> json, int year, int month, int day) {
        int milliseconds = new DateTime(year, month, day).millisecondsSinceEpoch;
        String daysRange = json['daysRange'] as String;

        if(daysRange.length == 2) {
            if(daysRange.substring(0, 1) == '-') {
                milliseconds -= int.parse(daysRange.substring(1)) * 24 * 60 * 60 * 1000;
            } else {
                milliseconds += int.parse(daysRange.substring(1)) * 24 * 60 * 60 * 1000;
            }
        } else {
            milliseconds += int.parse(daysRange) * 24 * 60 * 60 * 1000;
        }

        DateTime correct = new DateTime.fromMillisecondsSinceEpoch(milliseconds);
        
        return new NameDay(
            name: json['name'] as String,
            date: correct.day.toString() + "-" + correct.month.toString() + "-" + correct.year.toString(),
            hypocorisms: json['hypocorisms'] as String,
        );
    }
}

class NameDays {
	static List<NameDay> nameDaysList;
    final int year = new DateTime.now().year;
    int day;
    int month = 4;

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

            calculateEasterDay();

            namedays["movableNamedays"].forEach((nameday) {
                nameDaysList.add(NameDay.fromJsonMovable(nameday, year, month, day));
            });

            nameDaysList.sort((a, b) {
                return a.name.compareTo(b.name);
            });
        });
    }

    calculateEasterDay() {
        day  = (((19 * (year % 19) + 16) % 30) + ((2*(year % 4)+4*(year % 7) +6*((19 * (year % 19) + 16) % 30)) %7) + 3);
        
        if(day >= 31) {
            day = (day - 30);
            month = 5;
        }
    }

}