import 'package:podiynyk/storage/cloud.dart' show Cloud;


class Event {
	final String id;
	final String name;
	final String? subject;
	final DateTime date;

	String? note;

	Event({
		required this.id,
		required this.name,
		required this.subject,
		required this.date
	});

	Future<void> addDetails() => Cloud.addEventDetails(this);

	bool isBefore(Event event) => date.isBefore(event.date);
}
