import 'package:flutter/material.dart';

import 'package:podiynyk/storage/appearance.dart';
import 'package:podiynyk/storage/cloud.dart';
import 'package:podiynyk/storage/entities/event.dart';
import 'package:podiynyk/storage/entities/subject.dart' show Subject;

import 'package:podiynyk/ui/main/common/fields.dart';

import 'entity.dart';


class NewEventPage extends StatefulWidget {
	final bool askSubject;
	final bool subjectRequired;
	final Subject? subject;

	const NewEventPage() :
		askSubject = true,
		subjectRequired = false,
		subject = null;

	const NewEventPage.subjectEvent(this.subject) :
		askSubject = false,
		subjectRequired = true;

	const NewEventPage.nonSubjectEvent() :
		askSubject = false,
		subjectRequired = false,
		subject = null;

	@override
	State<NewEventPage> createState() => _NewEventPageState();
}

class _NewEventPageState extends State<NewEventPage> {
	static const _noSubjectsMessage = "no subjects";

	late final Future<List<Subject>> _subjects;
	final _nameField = TextEditingController();
	final _subjectField = TextEditingController();
	final _noteField = TextEditingController();

	Subject? _subject;
	DateTime? _date;

	@override
	void initState() {
		super.initState();
		_subject = widget.subject;
		if (widget.askSubject) _subjects = Cloud.subjects;
	}

	@override
	Widget build(BuildContext context) => NewEntityPage(
		add: _add,
		children: [
			InputField(
				controller: _nameField,
				name: "name",
				style: Appearance.titleText
			),
			if (widget.askSubject) OptionField(
				controller: _subjectField,
				name: "subject",
				showOptions: _askSubject,
				style: Appearance.contentText
			),
			DateField(
				onDatePicked: (date) => _date = date,
				style: Appearance.contentText
			),
			InputField(
				controller: _noteField,
				name: "note",
				style: Appearance.contentText
			)
		]
	);


	void _askSubject(BuildContext context) {
		Navigator.of(context).push(MaterialPageRoute(
			builder: (context) => Scaffold(
				body: Center(child: FutureBuilder(
					future: _subjects,
					builder: _subjectsBuilder
				))
			)
		));
	}

	Widget _subjectsBuilder(BuildContext context, AsyncSnapshot<List<Subject>> snapshot) {
		if (snapshot.connectionState == ConnectionState.waiting) return const Icon(Icons.cloud_download);
		// if (snapshot.hasError) print(snapshot.error);  // todo: consider handling

		final subjects = snapshot.data!;
		return subjects.isNotEmpty ? ListView(
			shrinkWrap: true,
			children: [
				for (final subject in subjects) if (subject != _subject) ListTile(
					title: Text(subject.nameRepr, style: Appearance.contentText),
					onTap: () => _handleSubject(context, subject)
				),
				if (_subject != null) ...[
					if (subjects.length != 1) const ListTile(),
					ListTile(
						title: const Text("none"),
						onTap: () => _handleSubject(context, null)
					)
				]
			]
		) : const Text(_noSubjectsMessage);
	}

	void _handleSubject(BuildContext context, Subject? subject) {
		_subject = subject;
		_subjectField.text = subject?.nameRepr ?? '';
		Navigator.of(context).pop();
	}

	bool _add() {
		final name = _nameField.text;
		if (
			name.isEmpty ||
			(widget.subjectRequired && _subject == null) ||
			_date == null
		) return false;

		final note = _noteField.text;
		final event = Event(
			name: name,
			subject: _subject,
			date: _date!,
			note: note.isNotEmpty ? note : null
		);
		Cloud.addEvent(event);
		return true;
	}
}
