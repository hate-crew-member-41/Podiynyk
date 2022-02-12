import 'package:flutter/material.dart';

import 'package:podiynyk/storage/cloud.dart' show Cloud;

import 'package:podiynyk/ui/main/widgets/fields.dart' show InputField;

import 'entity.dart';


class NewMessagePage extends StatelessWidget {
	final _subjectField = TextEditingController();
	final _contentField = TextEditingController();

	@override
	Widget build(BuildContext context) => NewEntityPage(
		addEntity: _add,
		children: [
			InputField(
				controller: _subjectField,
				name: "subject"
			),
			InputField(
				controller: _contentField,
				name: "content"
			)
		]
	);

	void _add(BuildContext context) {
		final subject = _subjectField.text, content = _contentField.text;
		if (subject.isEmpty || content.isEmpty) return;

		Navigator.of(context).pop();
		Cloud.addMessage(
			topic: subject,
			content: content,
		);
	}
}
