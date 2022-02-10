import 'package:flutter/material.dart';

import 'package:podiynyk/storage/cloud.dart' show Cloud;
import 'package:podiynyk/storage/entities/subject.dart';

import 'package:podiynyk/ui/main/widgets/fields.dart';

import '../section.dart' show EntityDate;
import 'entity.dart';


// todo: what if there are no subjects?
// todo: access the subjects through the context?
class NewEventPage extends StatefulWidget {
	final bool _askSubject;
	final bool _subjectRequired;
	final Subject? _subject;
	final List<Subject>? subjects;

	const NewEventPage({required List<Subject> this.subjects}) :
		_askSubject = true,
		_subjectRequired = false,
		_subject = null;

	const NewEventPage.subjectEvent(Subject subject) :
		_askSubject = false,
		_subjectRequired = true,
		_subject = subject,
		subjects = null;

	const NewEventPage.noSubjectEvent() :
		_askSubject = false,
		_subjectRequired = false,
		_subject = null,
		subjects = null;

	@override
	State<NewEventPage> createState() => _NewEventPageState();
}

class _NewEventPageState extends State<NewEventPage> {
	final _nameField = TextEditingController();
	final _subjectField = TextEditingController();
	final _dateField = TextEditingController();
	final _noteField = TextEditingController();

	Subject? _subject;
	DateTime? _date;

	@override
	void initState() {
		_subject = widget._subject;
		super.initState();
	}

	@override
	Widget build(BuildContext context) => NewEntityPage(
		addEntity: _add,
		children: [
			InputField(
				controller: _nameField,
				name: "name"
			),
			if (widget._askSubject) OptionField(
				controller: _subjectField,
				name: "subject",
				showOptions: (context) => _askSubject(context)
			),
			OptionField(
				controller: _dateField,
				name: "date",
				showOptions: _askDate
			),
			InputField(
				controller: _noteField,
				name: "note"
			)
		]
	);


	void _askSubject(BuildContext context) {
		Navigator.of(context).push(MaterialPageRoute(
			builder: (context) => Scaffold(
				body: Center(child: ListView(
					shrinkWrap: true,
					children: [for (final subject in widget.subjects!) ListTile(
						title: Text(subject.name),
						onTap: () {
							_subject = subject;
							_subjectField.text = subject.name;
							Navigator.of(context).pop();
						}
					)]
				))
			)
		));
	}

	Future<void> _askDate(BuildContext context) async {
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
		if (
			_nameField.text.isEmpty ||
			(widget._subjectRequired && _subject == null) ||
			_date == null
		) return;

		// idea: show an animation of the event flying away?
		// idea: show the result of the request on the page?
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
