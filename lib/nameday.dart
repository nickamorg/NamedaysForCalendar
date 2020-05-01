class NameDay {
	String name;
	String date;

	NameDay(String name, String date) {
		this.name = name;
		this.date = date;
	}

}

class NameDays {
	List<NameDay> nameDaysList;

	NameDays() {
		String year = new DateTime.now().year.toString();

		nameDaysList = <NameDay>[];
		nameDaysList.add(new NameDay("Dummy",     '29-04-' + year));
		nameDaysList.add(new NameDay("Dummy#2",   '30-04-' + year));
		nameDaysList.add(new NameDay("Dummy#3",   '30-04-' + year));
		nameDaysList.add(new NameDay("Βασίλειος", '01-01-' + year));
		nameDaysList.add(new NameDay("Σταμάτης",  '03-02-' + year));
		nameDaysList.add(new NameDay("Ιωάννης",   '06-03-' + year));
		nameDaysList.add(new NameDay("Λεωνίδας",  '15-04-' + year));
		nameDaysList.add(new NameDay("Ιάσονας",   '29-04-' + year));
		nameDaysList.add(new NameDay("Ιερεμίας",  '01-05-' + year));
		nameDaysList.add(new NameDay("Αχιλλέας",  '15-05-' + year));
		nameDaysList.add(new NameDay("Ηλίας",     '20-07-' + year));
		nameDaysList.add(new NameDay("Ιωσήφ",     '31-07-' + year));
		nameDaysList.add(new NameDay("Αλέξης",    '30-08-' + year));
		nameDaysList.add(new NameDay("Θωμάς",     '06-10-' + year));
		nameDaysList.add(new NameDay("Άγγελος",   '08-11-' + year));
		nameDaysList.add(new NameDay("Γρηγόρης",  '14-11-' + year));
		nameDaysList.add(new NameDay("Νικόλαος",  '06-12-' + year));
	}
}