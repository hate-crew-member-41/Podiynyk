import 'package:flutter/material.dart';

import 'package:podiynyk/storage/cloud.dart' show Cloud;
import 'package:podiynyk/storage/entities.dart' show Subject, Event;

import 'section.dart';


class SubjectsSection extends CloudListSection<Subject> {
	@override
	final name = "subjects";
	@override
	final icon = Icons.school;
	@override
	final hasAddAction = true;
	@override

	const SubjectsSection();

	@override
	Future<List<Subject>> get future => Cloud.subjects();

	@override
	ListTile tile(Subject subject) => ListTile(
		title: Text(subject.name),
		subtitle: Text(_eventCount(subject.events.length)),
		trailing: Text(_nextEvent(subject).date.dateRepr)
	);

	String _eventCount(int eventCount) {
		switch (eventCount.compareTo(1)) {
			case -1: return "no events";
			case 0: return "1 event";
			default: return "$eventCount events";
		}
	}

	Event _nextEvent(Subject subject) => subject.events.reduce(
		(nextEvent, event) => event.isBefore(nextEvent) ? event : nextEvent
	);

	@override
	void addAction(BuildContext context) {
		Navigator.of(context).push(MaterialPageRoute(
			builder: (context) => NewSubjectPage()
		));
	}
}


class NewSubjectPage extends StatelessWidget {
	final _nameField = TextEditingController();

	@override
	Widget build(BuildContext context) {
		return GestureDetector(
			onDoubleTap: () => _addSubject(context),
			child: Scaffold(
				body: Center(child: TextField(
					controller: _nameField,
					decoration: const InputDecoration(hintText: "Name"),
				))
			)
		);
	}

	void _addSubject(BuildContext context) {
		final name = _nameField.text;
		if (name.isEmpty) return;

		Navigator.of(context).pop();
		Cloud.addSubject(name: name);
	}
}
