import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:podiinyk/data/core/types/identifier.dart';
import 'package:podiinyk/data/core/types/object_map.dart';

import 'package:podiinyk/domain/core/types/entity_date.dart';
import 'package:podiinyk/domain/home/entities/subject.dart';


class Event {
	Event.fromCloud({
		required this.id,
		required ObjectMap object,
		required Map<String, Subject> subjects
	}) :
		name = object[Identifier.name.name],
		subject = object.containsKey(Identifier.subject.name) ?
			subjects[object[Identifier.subject.name]] :
			null,
		date = EntityDate(
			(object[Identifier.date.name] as Timestamp).toDate(),
			hasTime: object[Identifier.hasTime.name]
		),
		note = object[Identifier.note.name];

	final String id;
	final String name;
	final Subject? subject;
	final EntityDate date;
	final String? note;
}
