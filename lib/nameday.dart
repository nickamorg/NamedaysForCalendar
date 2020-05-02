class NameDay {
	String name;
	String date;
	String hypocorisms;
	bool saved;
	String eventID;

	NameDay({this.name, this.date, this.hypocorisms, this.saved = false, this.eventID});

	@override
	bool operator ==(Object other) => other is NameDay && other.date == this.date && other.name == this.name;
}

class NameDays {
	List<NameDay> nameDaysList;

	NameDays() {
		String year = new DateTime.now().year.toString();

		nameDaysList = <NameDay>[];
		nameDaysList.add(new NameDay(name: 'Βασίλειος', date: '01-01-' + year, hypocorisms: 'Βασίλης, Βάσος, Βασίλας, Μπίλλης, Μπίλης, Βασιλεία, Βασιλική, Βάσω, Βάσια, Βιβή, Βίκυ, Βίβιαν, Βασούλα, Βασιλίνα'));
		nameDaysList.add(new NameDay(name: 'Σταμάτης',  date: '03-02-' + year));
		nameDaysList.add(new NameDay(name: 'Ιωάννης',   date: '06-03-' + year));
		nameDaysList.add(new NameDay(name: 'Λεωνίδας',  date: '15-04-' + year));
		nameDaysList.add(new NameDay(name: 'Ιάσονας',   date: '29-04-' + year));
		nameDaysList.add(new NameDay(name: 'Ιερεμίας',  date: '01-05-' + year));
		nameDaysList.add(new NameDay(name: 'Αχιλλέας',  date: '15-05-' + year));
		nameDaysList.add(new NameDay(name: 'Ηλίας',     date: '20-07-' + year));
		nameDaysList.add(new NameDay(name: 'Ιωσήφ',     date: '31-07-' + year));
		nameDaysList.add(new NameDay(name: 'Αλέξης',    date: '30-08-' + year));
		nameDaysList.add(new NameDay(name: 'Θωμάς',     date: '06-10-' + year));
		nameDaysList.add(new NameDay(name: 'Άγγελος',   date: '08-11-' + year));
		nameDaysList.add(new NameDay(name: 'Γρηγόρης',  date: '14-11-' + year));
		nameDaysList.add(new NameDay(name: 'Νικόλαος',  date: '06-12-' + year));

		nameDaysList.sort((a, b) {
			List<int> date1 = a.date.split('-').map(int.parse).toList();
			List<int> date2 = b.date.split('-').map(int.parse).toList();

			return date1[1].compareTo(date2[1]) + date1[0].compareTo(date2[0]);
		});	
	}
}