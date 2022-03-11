import 'package:flutter/material.dart';

import 'package:podiynyk/storage/appearance.dart';
import 'package:podiynyk/storage/cloud.dart';
import 'package:podiynyk/storage/entities/message.dart';

import 'package:podiynyk/ui/main/common/fields.dart' show InputField;

import 'entity.dart';


class NewMessagePage extends StatelessWidget {
	final _nameField = TextEditingController();
	final _contentField = TextEditingController();

	@override
	Widget build(BuildContext context) => NewEntityPage(
		add: _add,
		children: [
			InputField(
				controller: _nameField,
				name: "topic",
				style: Appearance.titleText
			),
			InputField(
				controller: _contentField,
				name: "message",
				style: Appearance.contentText
			)
		]
	);

	bool _add() {
		final name = _nameField.text, content = _contentField.text;
		if (name.isEmpty || content.isEmpty) return false;

		final message = Message(
			name: name,
			content: content
		);
		Cloud.addMessage(message);
		return true;
	}
}
