import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:podiynyk/storage/appearance.dart';
import 'package:podiynyk/storage/cloud.dart';
import 'package:podiynyk/storage/entities/subject.dart';

import 'package:podiynyk/ui/main/common/fields.dart' show InputField;

import 'entity.dart';


class NewSubjectPage extends HookWidget {
	@override
	Widget build(BuildContext context) {
		final nameField = useTextEditingController();

		return NewEntityPage(
			handleForm: () => _handleForm(nameField.text),
			children: [
				InputField(
					controller: nameField,
					name: "name",
					style: Appearance.headlineText
				)
			]
		);
	}

	Future<bool> _handleForm(String name) async {
		if (name.isEmpty) return false;

		await Cloud.addSubject(Subject(name: name));
		return true;
	}
}


class NewSubjectInfoPage extends HookWidget {
	const NewSubjectInfoPage({required this.subject});

	final Subject subject;

	@override
	Widget build(BuildContext context) {
		final nameField = useTextEditingController();
		final contentField = useTextEditingController();

		return NewEntityPage(
			handleForm: () => _handleForm(nameField.text, contentField.text),
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

	Future<bool> _handleForm(String name, String content) async {
		if (name.isEmpty || content.isEmpty) return false;

		await subject.addInfo(SubjectInfo(
			subject: subject,
			name: name,
			content: content
		));
		return true;
	}
}
