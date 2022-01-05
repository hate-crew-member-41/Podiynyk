import 'package:flutter/material.dart';

import 'package:podiynyk/storage/cloud.dart';

import 'section.dart';


extension on int {
	String get twoDigitRepr => toString().padLeft(2, '0');
}

extension on DateTime {
	String forEvent() {
		String string = '${day.twoDigitRepr}.${month.twoDigitRepr}';
		if (hour != 0 || minute != 0) {
			string += ', ${hour.twoDigitRepr}:${minute.twoDigitRepr}';
		}

		return string;
	}
}


class AgendaSection extends Section {
	@override
	final name = "agenda";
	@override
	final icon = Icons.remove_red_eye;
	@override
	final hasAddAction = true;

	const AgendaSection();

	@override
	Widget build(BuildContext context) {
		return Center(child: Icon(icon));
	}
}


class AddEventButton extends StatefulWidget {
	const AddEventButton();

	@override
	_AddEventButtonState createState() => _AddEventButtonState();
}

class _AddEventButtonState extends State<AddEventButton> {
	late bool _isVisible;
	late List<String> _subjects;

	@override
	void initState() {
		_isVisible = false;
		Cloud.subjectNames().then((subjectNames) => setState(() {
			_isVisible = true;
			_subjects = subjectNames;
		}));

		super.initState();
	}

	@override
	Widget build(BuildContext context) {
		return Visibility(
			visible: _isVisible,
			child: AnimatedOpacity(
				opacity: _isVisible ? 1 : 0,
				duration: const Duration(milliseconds: 200),
				child: FloatingActionButton(
					child: const Icon(Icons.add),
					onPressed: () {
						Navigator.of(context).push(MaterialPageRoute(
							builder: (context) => NewEventPage(_subjects)
						));
					}
				)
			)
		);
	}
}


class NewEventPage extends StatefulWidget {
	late final bool _askSubject;
	late final bool _subjectRequired;
	late final String? _subject;
	late final List<String>? _subjects;

	final _nameField = TextEditingController();
	final _subjectField = TextEditingController();
	final _dateField = TextEditingController();
	final _noteField = TextEditingController();

	NewEventPage(List<String> subjects) {
		_askSubject = true;
		_subjectRequired = false;
		_subject = null;
		_subjects = subjects;
	}

	NewEventPage.subjectEvent(String subject) {
		_askSubject = false;
		_subjectRequired = true;
		_subject = subject;
		_subjects = null;
	}

	NewEventPage.noSubjectEvent() {
		_askSubject = false;
		_subjectRequired = false;
		_subject = null;
		_subjects = null;
	}

	@override
	State<NewEventPage> createState() => _NewEventPageState();
}

class _NewEventPageState extends State<NewEventPage> {
	String? _subject;
	DateTime? _date;

	@override
	void initState() {
		_subject = widget._subject;
		super.initState();
	}

	@override
	Widget build(BuildContext context) {
		return GestureDetector(
			onDoubleTap: () => _addEvent(context),
			child: Scaffold(
				body: Center(
					child: ListView(
						shrinkWrap: true,
						children: [
							TextField(
								controller: widget._nameField,
								decoration: const InputDecoration(hintText: "Name")
							),
							if (widget._askSubject) GestureDetector(  // TextField.onTap is not called if the field is disabled
								onTap: () => _askSubject(context),
								child: TextField(
									controller: widget._subjectField,
									enabled: false,
									decoration: const InputDecoration(hintText: "Subject")
								),
							),
							GestureDetector(
								onTap: () => _askDate(context),
								child: TextField(
									controller: widget._dateField,
									enabled: false,
									decoration: const InputDecoration(hintText: "Date")
								)
							),
							TextField(
								controller: widget._noteField,
								decoration: const InputDecoration(hintText: "Note")
							)
						]
					)
				)
			)
		);
	}

	void _askSubject(BuildContext context) {
		Navigator.of(context).push(MaterialPageRoute(
			builder: (context) => Scaffold(
				body: Center(child: ListView(
					shrinkWrap: true,
					children: [for (final subject in widget._subjects!) ListTile(
						title: Text(subject),
						onTap: () {
							_subject = subject;
							widget._subjectField.text = subject;
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
			widget._dateField.text = _date!.forEvent();
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

	void _addEvent(BuildContext context) {
		if (widget._askSubject) {
			final inputSubject = widget._subjectField.text;
			_subject = inputSubject.isNotEmpty ? inputSubject : null;
		}
		if (
			widget._nameField.text.isEmpty ||
			(widget._subjectRequired && _subject == null) ||
			_date == null
		) return;

		// these ideas apply to all new-entity pages
		// todo: show an animation of the event flying away?
		// todo: show the result of the request on the page?
		Navigator.of(context).pop();

		final note = widget._noteField.text;
		Cloud.addEvent(
			name: widget._nameField.text,
			subject: _subject,
			date: _date!,
			note: note.isNotEmpty ? note : null
		);
	}
}
