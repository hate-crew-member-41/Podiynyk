import 'package:flutter/material.dart';

import 'package:podiynyk/storage/cloud.dart' show Cloud;

import 'package:podiynyk/ui/main/common/fields.dart' show InputField;

import 'entity.dart';


class NewMessagePage extends StatelessWidget {
	final _topicField = TextEditingController();
	final _contentField = TextEditingController();

	@override
	Widget build(BuildContext context) => NewEntityPage(
		add: _add,
		children: [
			InputField(
				controller: _topicField,
				name: "topic"
			),
			InputField(
				controller: _contentField,
				name: "message"
			)
		]
	);

	bool _add(BuildContext context) {
		final subject = _topicField.text, content = _contentField.text;
		if (subject.isEmpty || content.isEmpty) return false;

		Cloud.addMessage(
			topic: subject,
			message: content,
		);
		return true;
	}
}
