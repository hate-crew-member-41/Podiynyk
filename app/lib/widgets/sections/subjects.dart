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


class NewSubjectPage extends StatelessWidget {
	final _nameField = TextEditingController();

	NewSubjectPage();

	@override
	Widget build(BuildContext context) {
		return GestureDetector(
			onDoubleTap: () => _addSubject(context),
			child: Scaffold(
				body: Center(
					child: TextField(  // todo: add auto-fill hints?
						controller: _nameField,
						decoration: const InputDecoration(hintText: "Name"),
						showCursor: false,
					)
				)
			)
		);
	}

	void _addSubject(BuildContext context) {
		if (_nameField.text.isEmpty) return;
		Navigator.of(context).pop();
		Cloud.addSubject(_nameField.text);
	}
}
