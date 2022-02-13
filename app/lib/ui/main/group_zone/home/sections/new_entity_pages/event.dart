import 'package:flutter/material.dart';

import 'package:podiynyk/storage/cloud.dart';

import 'package:podiynyk/ui/main/common/fields.dart';

import '../section.dart' show EntityDate;
import 'entity.dart';


// todo: what if there are no subjects?
// todo: access the subjects through the context?
class NewEventPage extends StatefulWidget {
	final bool _askSubject;
	final bool _subjectRequired;
	final String? _subjectName;
	final List<String>? subjectNames;

	const NewEventPage({required this.subjectNames}) :
		_askSubject = true,
		_subjectRequired = false,
		_subjectName = null;

	const NewEventPage.subjectEvent(String subject) :
		_askSubject = false,
		_subjectRequired = true,
		_subjectName = subject,
		subjectNames = null;

	const NewEventPage.noSubjectEvent() :
		_askSubject = false,
		_subjectRequired = false,
		_subjectName = null,
		subjectNames = null;

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
		_subjectName = widget._subjectName;
		super.initState();
	}

	@override
	Widget build(BuildContext context) => NewEntityPage(
		add: _add,
		children: [
			InputField(
				controller: _nameField,
				name: "name"
			),
			if (widget._askSubject) OptionField(
				controller: _subjectField,
				name: "subject",
				showOptions: _askSubject
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
					children: [
						for (final name in widget.subjectNames!) ListTile(
							title: Text(name),
							onTap: () {
								_subjectName = name;
								_subjectField.text = name;
								Navigator.of(context).pop();
							}
						)
					]
				))
			)
		));
	}

	Future<void> _askDate(BuildContext context) async {
		final now = DateTime.now();
		_date = await showDatePicker(
			context: context,
			initialDate: _date ?? now.add(const Duration(days: DateTime.daysPerWeek * 2)),
			firstDate: now,
			lastDate: now.add(const Duration(days: 365))
		);
		if (_date != null) {
			await _askTime(context);
			_dateField.text = _date!.fullRepr;
		}
	}

	Future<void> _askTime(BuildContext context) async {
		final time = await showTimePicker(
			context: context,
			initialTime: TimeOfDay.now().replacing(minute: 0)
		);
		if (time != null) _date = _date!.withTime(time);
	}

	bool _add(BuildContext context) {
		final name = _nameField.text;
		if (
			name.isEmpty ||
			(widget._subjectRequired && _subjectName == null) ||
			_date == null
		) return false;

		// idea: show an animation of the event flying away?
		// idea: show the result of the request on the page?

		final note = _noteField.text;
		Cloud.addEvent(
			name: name,
			subjectName: _subjectName,
			date: _date!,
			note: note.isNotEmpty ? note : null
		);
		return true;
	}
}
