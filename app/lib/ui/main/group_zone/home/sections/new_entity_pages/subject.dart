import 'package:flutter/material.dart';

import 'package:podiynyk/storage/cloud.dart';
import 'package:podiynyk/storage/entities/subject.dart';

import 'package:podiynyk/ui/main/common/fields.dart' show InputField;

import 'entity.dart';


class NewSubjectPage extends StatelessWidget {
	final _nameField = TextEditingController();

	@override
	Widget build(BuildContext context) => NewEntityPage(
		add: _add,
		children: [InputField(
			controller: _nameField,
			name: "name",
		)]
	);

	bool _add() {
		final name = _nameField.text;
		if (name.isEmpty) return false;

		Cloud.addSubject(name: name);
		return true;
	}
}


class NewSubjectInfoPage extends StatelessWidget {
	final Subject _subject;
	final _topicField = TextEditingController();
	final _infoField = TextEditingController();

	NewSubjectInfoPage(this._subject);

	@override
	Widget build(BuildContext context) => NewEntityPage(
		add: _add,
		children: [
			InputField(
				controller: _topicField,
				name: "topic"
			),
			InputField(
				controller: _infoField,
				name: "information"
			)
		]
	);

	bool _add() {
		final topic = _topicField.text, info = _infoField.text;
		if (topic.isEmpty || info.isEmpty) return false;

		_subject.info!.add(SubjectInfo(
			subject: _subject,
			name: topic,
			content: info
		));
		Cloud.updateSubjectInfo(_subject);
		return true;
	}
}
