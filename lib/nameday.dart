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
}

class NameDays {
	List<NameDay> nameDaysList;

	NameDays(bool flag) {
		nameDaysList = new List<NameDay>();

		if (!flag) return;

		String year = new DateTime.now().year.toString();

		// January
		nameDaysList.add(new NameDay(name: 'Βασίλειος',   date: '01-01-' + year, hypocorisms: 'Βασίλης, Βάσος, Βασίλας, Μπίλλης, Μπίλης, Βασιλεία, Βασιλική, Βάσω, Βάσια, Βιβή, Βίκυ, Βίβιαν, Βασούλα, Βασιλίνα'));
		nameDaysList.add(new NameDay(name: 'Εμμέλεια',    date: '01-01-' + year, hypocorisms: 'Εμμελεία'));
		nameDaysList.add(new NameDay(name: 'Σεραφείμ',    date: '02-01-' + year, hypocorisms: 'Σεραφειμία, Σεραφείμα, Σεραφίνα, Σεραφειμή, Σεραφειμούλα, Σεραφειμίτσα'));
		nameDaysList.add(new NameDay(name: 'Σίλβεστρος',  date: '02-01-' + year, hypocorisms: 'Σιλβέστρης, Σίλβης, Σιλβέστρα, Σίλβα'));
		nameDaysList.add(new NameDay(name: 'Γενοβέφα',    date: '03-01-' + year, hypocorisms: 'Γενεβιέβη'));
		nameDaysList.add(new NameDay(name: 'Θεωνάς',      date: '05-01-' + year, hypocorisms: 'Θεώνη'));
		nameDaysList.add(new NameDay(name: 'Θεόπεμπτος',  date: '05-01-' + year, hypocorisms: 'Θεόπεμπτη'));
		nameDaysList.add(new NameDay(name: 'Συγκλητική',  date: '05-01-' + year));
		nameDaysList.add(new NameDay(name: 'Φώτιος',      date: '06-01-' + year, hypocorisms: 'Φώτης, Φωτεινός, Φώτις, Φωτεινή, Φανή, Φένια, Φώτω, Φώφη, Φωτούλα, Φαίη, Φωφώ'));
		nameDaysList.add(new NameDay(name: 'Θεοφάνης',    date: '06-01-' + year, hypocorisms: 'Φάνης, Θεοφανία, Φάνια, Φανή, Φένια, Φανούλα'));
		nameDaysList.add(new NameDay(name: 'Ιορδάνης',    date: '06-01-' + year, hypocorisms: 'Ντάνης, Δάνης, Ιορδάνα, Ντάνα, Δάνα'));
		nameDaysList.add(new NameDay(name: 'Ουρανία',     date: '06-01-' + year, hypocorisms: 'Ράνια'));
		nameDaysList.add(new NameDay(name: 'Περιστέρα',   date: '06-01-' + year));
		nameDaysList.add(new NameDay(name: 'Θεοπούλα',    date: '07-01-' + year, hypocorisms: 'Θεόπη'));
		nameDaysList.add(new NameDay(name: 'Ιωάννης',     date: '07-01-' + year, hypocorisms: 'Γιάννης, Τζαννής, Τζανής, Γιάγκος, Ζαννέτος, Ζαννέττος, Γιάννα, Γιαννούλα, Ιωάννα, Ζαννέτα, Ζαννέττα, Ζανέτ'));
		nameDaysList.add(new NameDay(name: 'Πρόδρομος',   date: '07-01-' + year, hypocorisms: 'Προδρομάκης, Μάκης'));
		nameDaysList.add(new NameDay(name: 'Αγάθων',      date: '08-01-' + year));
		nameDaysList.add(new NameDay(name: 'Βασίλισσα',   date: '08-01-' + year));
		nameDaysList.add(new NameDay(name: 'Κέλσιος',     date: '08-01-' + year, hypocorisms: 'Κέλσια, Κέλσα, Κέλση'));
		nameDaysList.add(new NameDay(name: 'Δομινίκη',    date: '08-01-' + year, hypocorisms: 'Δομινίκη, Δομνίκα, Δομνίκη, Δομήνικος'));
		nameDaysList.add(new NameDay(name: 'Παρθένα',     date: '08-01-' + year, hypocorisms: 'Έλσα, Έλση, Νένα'));
 		nameDaysList.add(new NameDay(name: 'Θεοδόσιος',   date: '11-01-' + year, hypocorisms: 'Θεοδόσης, Δόσιος, Δόσης'));
		nameDaysList.add(new NameDay(name: 'Τατιανή',     date: '12-01-' + year, hypocorisms: 'Τατιάνα, Τάτια, Τίτη, Τάνια'));
		nameDaysList.add(new NameDay(name: 'Μέρτιος',     date: '12-01-' + year, hypocorisms: 'Μέρτος, Μέρτης, Μύρτος, Μερτία, Μέρτα, Μέρτη, Μερτούλα, Μυρτιά, Μυρτούλα'));
		nameDaysList.add(new NameDay(name: 'Ερμύλλος',    date: '13-01-' + year, hypocorisms: 'Ερμίλλος, Ερμύλλη, Ερμίλλη, Ερμύλα'));
		nameDaysList.add(new NameDay(name: 'Νίνα',        date: '14-01-' + year));
		nameDaysList.add(new NameDay(name: 'Δαν',         date: '16-01-' + year, hypocorisms: 'Δανάη'));
		nameDaysList.add(new NameDay(name: 'Αντώνιος',    date: '17-01-' + year, hypocorisms: 'Αντώνης, Τόνης, Νάκος, Αντώνας, Αντωνάκος, Αντωνάκης, Τόνυ, Αντωνία, Αντωνούλα, Τόνια'));
		nameDaysList.add(new NameDay(name: 'Θεοδόσιος',   date: '17-01-' + year, hypocorisms: 'Θεοδόσης, Δόσιος, Δόσης'));
		nameDaysList.add(new NameDay(name: 'Αθανάσιος',   date: '18-01-' + year, hypocorisms: 'Θανάσης, Νάσος, Σάκης, Θάνος, Θανάσος, Θανασάκης, Σούλης, Αθανασία, Νάσια, Νάνσυ, Θανασία, Θανασούλα, Σούλα, Νάσα, Σούλη'));
		nameDaysList.add(new NameDay(name: 'Κύριλλος',    date: '18-01-' + year, hypocorisms: 'Κυριλλία, Κυρίλλα, Κυρίλλη'));
		nameDaysList.add(new NameDay(name: 'Θεόδουλος',   date: '18-01-' + year, hypocorisms: 'Θεοδούλιος, Θεοδούλης, Θεοδουλία, Θεοδούλα, Θεόδουλη'));
		nameDaysList.add(new NameDay(name: 'Ευφρασία',    date: '19-01-' + year, hypocorisms: 'Ευφρασίτσα'));
		nameDaysList.add(new NameDay(name: 'Μακάριος',    date: '19-01-' + year, hypocorisms: 'Μακάρης, Μακαράς, Μακαρία, Μακάρω, Μακαρίτσα, Μακαρούλα'));
		nameDaysList.add(new NameDay(name: 'Ευθύμιος',    date: '20-01-' + year, hypocorisms: 'Ευθύμης, Θύμιος, Θέμης, Ευθυμία, Ευθυμούλα'));
		nameDaysList.add(new NameDay(name: 'Θύρσος',      date: '20-01-' + year, hypocorisms: 'Θύρσης, Θύρσα, Θύρση'));
		nameDaysList.add(new NameDay(name: 'Φαβιανός',    date: '20-01-' + year));
		nameDaysList.add(new NameDay(name: 'Αγνή',        date: '21-01-' + year, hypocorisms: 'Αγνούλα'));
		nameDaysList.add(new NameDay(name: 'Ευγένιος',    date: '21-01-' + year, hypocorisms: 'Ευγένης'));
		nameDaysList.add(new NameDay(name: 'Μάξιμος',     date: '21-01-' + year, hypocorisms: 'Μάξιμη, Μάξιμα'));
		nameDaysList.add(new NameDay(name: 'Νεόφυτος',    date: '21-01-' + year, hypocorisms: 'Νεοφυτία, Νεοφύτη'));
		nameDaysList.add(new NameDay(name: 'Πάτροκλος',   date: '21-01-' + year, hypocorisms: 'Πατρόκλειος, Πατροκλέας, Πατροκλής, Πατρόκλεια, Πατροκλά, Πάτρα, Πατρούλα'));
		nameDaysList.add(new NameDay(name: 'Αναστάσιος',  date: '22-01-' + year, hypocorisms: 'Τάσος, Αναστάσης, Ανέστης, Αναστασία, Τασούλα'));
		nameDaysList.add(new NameDay(name: 'Τιμόθεος',    date: '22-01-' + year, hypocorisms: 'Τίμος, Τιμάς, Τίμης, Θέος, Τιμοθέη, Τιμοθέα, Τίμα, Τίμη, Θέα, Θέη'));
		nameDaysList.add(new NameDay(name: 'Αγαθάγγελος', date: '23-01-' + year, hypocorisms: 'Αγαθαγγέλα, Αγαθαγγέλη'));
		nameDaysList.add(new NameDay(name: 'Διονύσιος',   date: '23-01-' + year, hypocorisms: 'Διονύσης, Νιόνιος, Νύσης, Ντένης, Διονυσία, Διονυσούλα, Νύσα, Σίσσυ, Ντενίζ'));
		nameDaysList.add(new NameDay(name: 'Ζωσιμάς',     date: '24-01-' + year, hypocorisms: 'Ζωσιμίνα'));
		nameDaysList.add(new NameDay(name: 'Ξένος',       date: '24-01-' + year, hypocorisms: 'Ξένιος, Ξένη, Ξένια'));
		nameDaysList.add(new NameDay(name: 'Φίλωνας',     date: '24-01-' + year, hypocorisms: 'Φίλων'));
		nameDaysList.add(new NameDay(name: 'Γρηγόρης',    date: '25-01-' + year, hypocorisms: 'Γρηγόριος, Γόλης, Γρηγορία'));
		nameDaysList.add(new NameDay(name: 'Μαργαρίτης',  date: '25-01-' + year, hypocorisms: 'Μαργαρίτα'));
		nameDaysList.add(new NameDay(name: 'Ξενοφών',     date: '26-01-' + year, hypocorisms: 'Ξενοφώντας, Φώντας, Φόντας, Φόνης, Ξενοφωντία, Ξενοφωντίνα, Ξενοφούλα, Ξενοφώντη, Ξένια'));
		nameDaysList.add(new NameDay(name: 'Χρυσόστομος', date: '27-01-' + year, hypocorisms: 'Χρυσοστόμης, Χρυσοστόμη, Χρυσοστομία, Χρυσοστομίτσα'));
		nameDaysList.add(new NameDay(name: 'Παλλάδιος',   date: '28-01-' + year, hypocorisms: 'Παλάδιος, Παλλάδης, Παλάδης'));
		nameDaysList.add(new NameDay(name: 'Χάρις',       date: '28-01-' + year));
		nameDaysList.add(new NameDay(name: 'Βαρσιμαίος',  date: '29-01-' + year, hypocorisms: 'Βαρσάμης, Βαρσαμία, Βαρσάμω, Βαλσάμω, Βαλσαμία'));
		nameDaysList.add(new NameDay(name: 'Αρχοντής',    date: '30-01-' + year, hypocorisms: 'Αρχοντίων, Αρχοντίωνας, Αρχοντία, Αρχοντή, Αρχοντούλα, Αρχόντισσα, Αρχόντω'));
		nameDaysList.add(new NameDay(name: 'Μαύρος',      date: '30-01-' + year, hypocorisms: 'Μαυρουδής, Μαυροειδής, Μαυρέτα'));
		nameDaysList.add(new NameDay(name: 'Χρυσή',       date: '30-01-' + year, hypocorisms: 'Χρύσα, Χρυσαλία, Χρυσαυγή, Χρυσούλα, Σήλια, Χρυστάλλα, Χρυσταλλία'));
		nameDaysList.add(new NameDay(name: 'Κύρος',       date: '31-01-' + year, hypocorisms: 'Κύρης'));
		nameDaysList.add(new NameDay(name: 'Ευδοξία',     date: '31-01-' + year, hypocorisms: 'Ευδοξούλα, Δόξα, Δοξούλα'));

		// Other dates
		nameDaysList.add(new NameDay(name: 'Σταμάτης',   date: '03-02-' + year));
		nameDaysList.add(new NameDay(name: 'Ιωάννης',    date: '06-03-' + year));
		nameDaysList.add(new NameDay(name: 'Λεωνίδας',   date: '15-04-' + year));
		nameDaysList.add(new NameDay(name: 'Ιάσονας',    date: '29-04-' + year));
		nameDaysList.add(new NameDay(name: 'Ιερεμίας',   date: '01-05-' + year));
		nameDaysList.add(new NameDay(name: 'Αχιλλέας',   date: '15-05-' + year));
		nameDaysList.add(new NameDay(name: 'Ηλίας',      date: '20-07-' + year));
		nameDaysList.add(new NameDay(name: 'Ιωσήφ',      date: '31-07-' + year));
		nameDaysList.add(new NameDay(name: 'Αλέξης',     date: '30-08-' + year));
		nameDaysList.add(new NameDay(name: 'Θωμάς',      date: '06-10-' + year));
		nameDaysList.add(new NameDay(name: 'Άγγελος',    date: '08-11-' + year));
		nameDaysList.add(new NameDay(name: 'Γρηγόρης',   date: '14-11-' + year));
		nameDaysList.add(new NameDay(name: 'Νικόλαος',   date: '06-12-' + year));

		nameDaysList.sort((a, b) {
			return a.name.compareTo(b.name);
		});
	}

	void sort() {
		nameDaysList.sort((a, b) {
			return a.name.compareTo(b.name);
		});
	}
}