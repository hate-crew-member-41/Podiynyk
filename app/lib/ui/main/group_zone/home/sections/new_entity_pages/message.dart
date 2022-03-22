import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:podiynyk/storage/appearance.dart';
import 'package:podiynyk/storage/cloud.dart';
import 'package:podiynyk/storage/entities/message.dart';

import 'package:podiynyk/ui/main/common/fields.dart' show InputField;

import 'entity.dart';


class NewMessagePage extends HookWidget {
	@override
	Widget build(BuildContext context) {
		final nameField = useTextEditingController();
		final contentField = useTextEditingController();

		return NewEntityPage(
			add: () => _add(nameField.text, contentField.text),
			children: [
				InputField(
					controller: nameField,
					name: "topic",
					style: Appearance.headlineText
				),
				InputField(
					controller: contentField,
					name: "content",
					multiline: true,
					style: Appearance.bodyText,
				)
			]
		);
	}

	bool _add(String name, String content) {
		if (name.isEmpty || content.isEmpty) return false;

		Cloud.addMessage(Message(
			name: name,
			content: content
		));
		return true;
	}
}
