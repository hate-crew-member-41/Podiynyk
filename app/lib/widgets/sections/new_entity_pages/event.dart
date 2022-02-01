import 'package:flutter/material.dart';

import 'package:podiynyk/storage/cloud.dart' show Cloud;

import '../section.dart' show EntityDate;
import 'entity.dart';


class NewEventPage extends StatefulWidget {
	final bool _askSubject;
	final bool _subjectRequired;
	final String? _subject;
	final List<String>? _subjectNames;

	NewEventPage(List<String> subjectNames) :
		_askSubject = true,
		_subjectRequired = false,
		_subject = null,
		_subjectNames = subjectNames;

	NewEventPage.subjectEvent(String subject) :
		_askSubject = false,
		_subjectRequired = true,
		_subject = subject,
		_subjectNames = null;

	NewEventPage.noSubjectEvent() :
		_askSubject = false,
		_subjectRequired = false,
		_subject = null,
		_subjectNames = null;

	@override
	State<NewEventPage> createState() => _NewEventPageState();
}

class _NewEventPageState extends State<NewEventPage> {
	final _nameField = TextEditingController();
	final _subjectField = TextEditingController();
	final _dateField = TextEditingController();
	final _noteField = TextEditingController();

	String? _subjectName;
	DateTime? _date;

	@override
	void initState() {
		_subjectName = widget._subject;
		super.initState();
	}

	@override
	Widget build(BuildContext context) => NewEntityPage(
		addEntity: _add,
		children: [
			TextField(
				controller: _nameField,
				decoration: const InputDecoration(hintText: "name")
			),
			if (widget._askSubject) GestureDetector(
				onTap: () => _askSubject(context),
				child: TextField(
					controller: _subjectField,
					enabled: false,
					decoration: const InputDecoration(hintText: "subject")
				)
			),
			GestureDetector(
				onTap: () => _askDate(context),
				child: TextField(
					controller: _dateField,
					enabled: false,
					decoration: const InputDecoration(hintText: "date")
				)
			),
			TextField(
				controller: _noteField,
				decoration: const InputDecoration(hintText: "note")
			)
		]
	);


	void _askSubject(BuildContext context) {
		Navigator.of(context).push(MaterialPageRoute(
			builder: (context) => Scaffold(
				body: Center(child: ListView(
					shrinkWrap: true,
					children: [for (final name in widget._subjectNames!) ListTile(
						title: Text(name),
						onTap: () {
							_subjectName = name;
							_subjectField.text = name;
							Navigator.of(context).pop();
						}
					)]
				))
			)
		));
	}

	void _askDate(BuildContext context) async {
		final now = DateTime.now();
		_date = await showDatePicker(
			context: context,
			initialDate: _date ?? now.add(const Duration(days: 7)),
			firstDate: now,
			lastDate: now.add(const Duration(days: 365 * 4 + 1))
		);
		if (_date != null) {
			await _askTime(context);
			_dateField.text = _date!.fullRepr;
		}
	}

	Future<void> _askTime(BuildContext context) async {
		final time = await showTimePicker(
			context: context,
			initialTime: const TimeOfDay(hour: 8, minute: 30)
		);
		if (time != null) {
			_date = DateTime(_date!.year, _date!.month, _date!.day, time.hour, time.minute);
		}
	}

	void _add(BuildContext context) {
		if (widget._askSubject) {
			final inputSubject = _subjectField.text;
			_subjectName = inputSubject.isNotEmpty ? inputSubject : null;
		}
		if (
			_nameField.text.isEmpty ||
			(widget._subjectRequired && _subjectName == null) ||
			_date == null
		) return;

		// idea: show an animation of the event flying away?
		// idea: show the result of the request on the page?
		Navigator.of(context).pop();

		final note = _noteField.text;
		Cloud.addEvent(
			name: _nameField.text,
			subject: _subjectName,
			date: _date!,
			note: note.isNotEmpty ? note : null
		);
	}
}
