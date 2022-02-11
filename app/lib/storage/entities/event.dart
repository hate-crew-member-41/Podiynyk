import '../cloud.dart' show Cloud;

import '../fields.dart';
import 'entity.dart';
import 'subject.dart';


typedef EventEssence = Map<String, String?>;


class Event implements DetailedEntity, StoredEntity<EventEssence> {
	final String id;
	final String name;
	final Subject? subject;
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
		Field.name.name: name, 
		Field.subject.name: subject?.id
	};

	@override
	bool essenceIs(EventEssence comparedTo) {
		return name == comparedTo[Field.name.name] && subject?.id == comparedTo[Field.subject.name];
	}

	bool isBefore(Event event) => date.isBefore(event.date);
}
