import 'package:flutter/material.dart';

import 'package:podiynyk/storage/cloud.dart';

import 'package:podiynyk/ui/main/common/fields.dart';

import 'entity.dart';


// todo: what if there are no subjects?
// todo: exclude the unfollowed subjects from the options?
// todo: access the subjectNames through the context?
class NewEventPage extends StatefulWidget {
	final bool _askSubject;
	final bool _subjectRequired;
	final String? _subjectName;
	final List<String>? subjectNames;

	const NewEventPage({required this.subjectNames}) :
		_askSubject = true,
		_subjectRequired = false,
		_subjectName = null;

	const NewEventPage.subjectEvent(String subjectName) :
		_askSubject = false,
		_subjectRequired = true,
		_subjectName = subjectName,
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
			// todo: removing the chosen subject
			if (widget._askSubject) OptionField(
				controller: _subjectField,
				name: "subject",
				showOptions: _askSubject
			),
			DateField(onDatePicked: (date) => _date = date),
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
