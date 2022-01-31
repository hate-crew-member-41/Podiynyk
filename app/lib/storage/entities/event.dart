import '../cloud.dart' show Cloud;

import 'entity.dart';


typedef EventEssence = Map<String, String?>;


class Event implements DetailedEntity, StoredEntity<EventEssence> {
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

	@override
	Future<void> addDetails() => Cloud.addEventDetails(this);

	@override
	EventEssence get essence => {
		'name': name, 
		'subject': subject
	};

	@override
	bool essenceIs(EventEssence comparedTo) => name == comparedTo['name'] && subject == comparedTo['subject'];

	bool isBefore(Event event) => date.isBefore(event.date);
}
