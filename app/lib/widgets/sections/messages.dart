import 'package:flutter/material.dart';

import 'package:podiynyk/storage/cloud.dart' show Cloud;
import 'package:podiynyk/storage/entities.dart' show Message;

import 'section.dart';


class MessagesSection extends ExtendableListSection<Message> {
	@override
	final name = "messages";
	@override
	final icon = Icons.messenger;

	const MessagesSection();

	@override
	Future<List<Message>> get entities => Cloud.messages();

	@override
	ListTile tile(Message message) => ListTile(
		title: Text(message.subject),
		trailing: Text(message.date.dateRepr)
	);

	@override
	Widget get newEntityPage => NewMessagePage();
}


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
