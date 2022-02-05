import 'package:flutter/material.dart';

import 'package:podiynyk/storage/cloud.dart' show Cloud;

import 'entity.dart';


class NewMessagePage extends StatelessWidget {
	final _subjectField = TextEditingController();
	final _contentField = TextEditingController();

	@override
	Widget build(BuildContext context) => NewEntityPage(
		addEntity: _add,
		children: [
			TextField(
				controller: _subjectField,
				decoration: const InputDecoration(hintText: "subject"),
			),
			TextField(
				controller: _contentField,
				decoration: const InputDecoration(hintText: "content"),
			)
		]
	);

	void _add(BuildContext context) {
		final subject = _subjectField.text, content = _contentField.text;
		if (subject.isEmpty || content.isEmpty) return;

		Navigator.of(context).pop();
		Cloud.addMessage(
			subject: subject,
			content: content,
		);
	}
}
