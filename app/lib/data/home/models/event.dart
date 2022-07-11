import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:podiinyk/domain/core/types/entity_date.dart';
import 'package:podiinyk/domain/home/entities/event.dart';
import 'package:podiinyk/domain/home/entities/subject.dart';

import '../../core/types/field.dart';


class EventModel extends Event {
	EventModel(
		MapEntry<String, dynamic> entry,
		{required Iterable<Subject> subjects}
	) : super(
		id: entry.key,
		name: entry.value[Field.name.name],
		subject: entry.value.containsKey(Field.subject.name) ?
			subjects.firstWhere((subject) => subject.id == entry.value[Field.subject.name]) :
			null,
		date: EntityDate(
			(entry.value[Field.date.name] as Timestamp).toDate(),
			hasTime: entry.value[Field.hasTime.name]
		),
		note: entry.value[Field.note.name]
	);
}
