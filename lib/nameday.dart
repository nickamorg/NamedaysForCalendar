import 'package:flutter/services.dart' show rootBundle;
import 'dart:async' show Future;
import 'dart:convert';

class Normalizer {
	static List<List<String>> letters = [['ά', 'α'], ['έ', 'ε'], ['ή', 'η'], ['ί', 'ι'], ['ό', 'ο'], ['ύ', 'υ'], ['ώ', 'ω']];

	static String normalize(String str) {
		letters.forEach((letter) => str = str.toLowerCase().replaceAll(letter[0], letter[1]));

		return str;
	}
}

class NameDay {
	String name;
	String date;
	String hypocorisms;
	String eventID;

	NameDay({this.name, this.date, this.hypocorisms = '', this.eventID});

	@override
	bool operator == (Object other) => other is NameDay && other.date == date && other.name == name;

  	int get hashCode => name.hashCode ^ name.hashCode ^ hypocorisms.hashCode;

	bool operator > (String other) {
		String substring = Normalizer.normalize(other);
		String newName = Normalizer.normalize(name);
		String newHypocorisms = Normalizer.normalize(hypocorisms);

		return newName.startsWith(substring) || newHypocorisms.startsWith(substring) || newHypocorisms.contains(', ' + substring) || date.contains(substring);
	}

    factory NameDay.fromJson(Map<String, dynamic> json) {
        return NameDay(
            name: json['name'] as String,
            date: (json['date'] as String) + '-' + DateTime.now().year.toString(),
            hypocorisms: json['hypocorisms'] as String,
        );
    }

    factory NameDay.fromJsonMovable(Map<String, dynamic> json, int day, int month, int year) {
        int milliseconds = DateTime(year, month, day).millisecondsSinceEpoch;
        String daysRange = json['daysRange'] as String;

		milliseconds += int.parse(daysRange) * 24 * 60 * 60 * 1000;

        DateTime correct = DateTime.fromMillisecondsSinceEpoch(milliseconds);

        return NameDay(
            name: json['name'] as String,
            date: (correct.day < 10 ? '0' : '') + correct.day.toString() + '-' + (correct.month < 10 ? '0' : '') + correct.month.toString() + '-' + correct.year.toString(),
            hypocorisms: json['hypocorisms'] as String,
        );
    }

	factory NameDay.fromJsonSpecial(Map<String, dynamic> json, int day, int month, int year) {
		DateTime correct;

		if (json['name'] == 'Χλόη') {
			correct = DateTime(year, 2, 13);
			correct = DateTime(year, 2, 13 + 7 - correct.weekday);
		} else if(json['name'] == 'Γεωργία' || json['name'] == 'Γεώργιος') {
			correct = DateTime(year, 4, 23);

			if (month == 5 || (month == 4 && day > 23)) {
				correct = DateTime(year, month, day + 1);
			}
		} else if(json['name'] == 'Μάρκος') {
			correct = DateTime(year, 4, 25);

			if (month == 5 || (month == 4 && day > 23)) {
				correct = DateTime(year, month, day + 2);
			}
		} else {
			correct = DateTime(year, 12, 11);
			correct = DateTime(year, 12, 11 + 7 - correct.weekday);
		}

		return NameDay(
			name: json['name'] as String,
            date: (correct.day < 10 ? '0' : '') + correct.day.toString() + '-' + (correct.month < 10 ? '0' : '') + correct.month.toString() + '-' + correct.year.toString(),
			hypocorisms: json['hypocorisms'] as String,
		);
    }
}

class NameDays {
	static List<NameDay> nameDaysList;
    final int year = DateTime.now().year;
    int day;
    int month = 4;

    NameDays() {
		nameDaysList = List<NameDay>();

        Future<String> loadAsset() async {
            return await rootBundle.loadString('assets/namedays.json');
        }

        loadAsset().then((val) {
            Map<String, dynamic> nameDays = jsonDecode(val);
            nameDays['NameDays'].forEach((nameDay) {
                nameDaysList.add(NameDay.fromJson(nameDay));
            });

            calculateEasterDay();

            nameDays['MovableNameDays'].forEach((nameDay) {
                nameDaysList.add(NameDay.fromJsonMovable(nameDay, day, month, year));
            });

			nameDays['SpecialNameDays'].forEach((nameDay) {
                nameDaysList.add(NameDay.fromJsonSpecial(nameDay, day, month, year));
            });

            nameDaysList.sort((a, b) {
                return Normalizer.normalize(a.name).compareTo(Normalizer.normalize(b.name));
            });
        });
    }

    calculateEasterDay() {
        int dblFragment = (19 * (year % 19) + 16) % 30;
        day  = (dblFragment + ((2 * (year % 4) + 4 * (year % 7) + 6 * (dblFragment)) % 7) + 3);

        if (day >= 31) {
            day = (day - 30);
            month = 5;
        }
    }

	static NameDay findNameDayByName(NameDay nameDay) {
		List<NameDay> nameDays = nameDaysList.where((element) => element.name == nameDay.name).toList();

		if (nameDays.length == 1) return nameDays[0];

		for (int i = 0; i < nameDays.length; i++) {
			if (nameDays[i].date.startsWith(nameDay.date.substring(5))) return nameDays[i];
		}

		return nameDays[0];
	}
}