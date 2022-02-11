import 'package:cloud_firestore/cloud_firestore.dart';

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

	Event.fromCloudFormat(MapEntry<String, dynamic> entry, {required this.subject}) :
		id = entry.key,
		name = entry.value[Field.name.name] as String,
		date = (entry.value[Field.date.name] as Timestamp).toDate();

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
