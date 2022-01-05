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

	@override
	void addAction(BuildContext context) {
		Navigator.of(context).push(MaterialPageRoute(
			builder: (context) => NewEventPage()
		));
	}
}


// todo: make the widget stateful even though mutable [subject] and [_date] do not change the appearance?
class NewEventPage extends StatelessWidget {
	late final bool _askSubject;
	late final bool _subjectRequired;

	String? _subject;
	DateTime? _date;

	final _nameField = TextEditingController();
	final _subjectField = TextEditingController();
	final _dateField = TextEditingController();
	final _noteField = TextEditingController();

	NewEventPage() {
		_askSubject = true;
		_subjectRequired = false;
	}

	NewEventPage.subjectEvent(String subject) {
		_askSubject = false;
		_subjectRequired = true;
		_subject = subject;
	}

	NewEventPage.independentEvent() {
		_askSubject = false;
		_subjectRequired = false;
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
								controller: _nameField,
								decoration: const InputDecoration(hintText: "Name")
							),
							if (_askSubject) TextField(  // todo: validate
								controller: _subjectField,
								decoration: const InputDecoration(hintText: "Subject")
							),
							GestureDetector(  // the onTap of a disabled TextField never happens
								onTap: () => _askDate(context),
								child: TextField(
									controller: _dateField,
									enabled: false,
									decoration: const InputDecoration(hintText: "Date")
								)
							),
							TextField(
								controller: _noteField,
								decoration: const InputDecoration(hintText: "Note")
							)
						]
					)
				)
			)
		);
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
			_dateField.text = _date!.forEvent();
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
		if (_askSubject) {
			final inputSubject = _subjectField.text;
			_subject = inputSubject.isNotEmpty ? inputSubject : null;
		}
		if (
			_nameField.text.isEmpty ||
			(_subjectRequired && _subject == null) ||
			_date == null
		) return;

		// these ideas apply to all new-entity pages
		// todo: show an animation of the event flying away?
		// todo: show the result of the request on the page?
		Navigator.of(context).pop();

		final note = _noteField.text;
		Cloud.addEvent(
			name: _nameField.text,
			subject: _subject,
			date: _date!,
			note: note.isNotEmpty ? note : null
		);
	}
}
