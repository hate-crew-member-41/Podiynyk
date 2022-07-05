import 'package:cloud_firestore/cloud_firestore.dart';

import '../../types/entity_date.dart';
import '../../types/field.dart';
import '../../types/object_map.dart';

import 'subject.dart';


class Event {
	const Event({
		required this.id,
		required this.name,		
		this.subject,
		required this.date,
		this.note
	});

	Event.fromCloud({
		required this.id,
		required ObjectMap object,
		required Map<String, Subject> subjects
	}) :
		name = object[Field.name.name],
		subject = object.containsKey(Field.subject.name) ?
			subjects[object[Field.subject.name]] :
			null,
		date = EntityDate(
			(object[Field.date.name] as Timestamp).toDate(),
			hasTime: object[Field.hasTime.name]
		),
		note = object[Field.note.name];

	final String id;
	final String name;
	final Subject? subject;
	final EntityDate date;

	final String? note;

	ObjectMap get cloudObject => {
		Field.name.name: name,
		if (subject != null) Field.subject.name: subject!.id,
		Field.date.name: date.object,
		Field.hasTime.name: date.hasTime,
		if (note != null) Field.note.name: note
	};
}
