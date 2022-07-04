import 'package:flutter/material.dart';

import 'package:podiinyk/data/types.dart';

import 'subject.dart';


class Event {
	const Event({
		required this.id,
		required this.name,		
		this.subject,
		required this.date,
		this.time,
		this.note
	});

	Event.fromCloud({
		required this.id,
		required ObjectMap object,
		required Map<String, Subject> subjects
	}) :
		name = object[Field.name.name],
		subject = object.containsKey(Field.subject.name) ? subjects[object[Field.subject.name]] : null,
		date = object[Field.date.name],
		time = object[Field.time.name],
		note = object[Field.note.name];

	final String id;
	final String name;
	final Subject? subject;
	final DateTime date;
	final TimeOfDay? time;
	final String? note;

	ObjectMap get cloudObject => {
		Field.name.name: name,
		if (subject != null) Field.subject.name: subject,
		Field.date.name: date,
		if (time != null) Field.time.name: time,
		if (note != null) Field.note.name: note
	};
}
