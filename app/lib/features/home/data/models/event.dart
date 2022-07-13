import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:podiinyk/core/data/types/field.dart';
import 'package:podiinyk/core/domain/types/date.dart';

import '../../domain/entities/event.dart';
import '../../domain/entities/subject.dart';


class EventModel extends Event {
	EventModel(
		MapEntry<String, dynamic> entry,
		{required Iterable<Subject> subjects}
	) : super(
		id: entry.key,
		name: entry.value[Field.name.name],
		subject: entry.value.containsKey(Field.subject.name) ?
			subjects.firstWhere((s) => s.id == entry.value[Field.subject.name]) :
			null,
		date: Date(
			(entry.value[Field.date.name] as Timestamp).toDate(),
			hasTime: entry.value[Field.hasTime.name]
		),
		note: entry.value[Field.note.name]
	);
}
