import 'package:flutter/material.dart';

import 'package:podiynyk/storage/cloud.dart';

import 'section.dart';


class SubjectsSection extends Section {
	@override
	final name = "subjects";
	@override
	final icon = Icons.school;
	@override
	final hasAddAction = true;

	const SubjectsSection();

	@override
	Widget build(BuildContext context) {
		return Center(child: Icon(icon));
	}

	@override
	void addAction(BuildContext context) {
		Navigator.of(context).push(MaterialPageRoute(
			builder: (context) => NewSubjectPage()
		));
	}
}


// todo: make NewSubjectPage and NewEventPage share code (define NewEntityPage class)
class NewSubjectPage extends StatelessWidget {
	final _nameField = TextEditingController();

	@override
	Widget build(BuildContext context) {
		return GestureDetector(
			onDoubleTap: () => _addSubject(context),
			child: Scaffold(
				body: Center(
					child: TextField(
						controller: _nameField,
						decoration: const InputDecoration(hintText: "Name"),
					)
				)
			)
		);
	}

	void _addSubject(BuildContext context) {
		if (_nameField.text.isEmpty) return;
		Navigator.of(context).pop();
		Cloud.addSubject(name: _nameField.text);
	}
}
