import 'package:flutter/material.dart';

import 'package:podiynyk/storage/cloud.dart' show Cloud;
import 'package:podiynyk/storage/entities.dart' show Message;

import 'section.dart';


class MessagesSection extends CloudListSection<Message> {
	@override
	final name = "messages";
	@override
	final icon = Icons.messenger;
	@override
	final hasAddAction = true;

	const MessagesSection();

	@override
	Future<List<Message>> get future => Cloud.messages();

	@override
	ListTile tile(Message message) => ListTile(
		title: Text(message.subject),
		trailing: Text(message.date.dateRepr)
	);

	@override
	void addAction(BuildContext context) {
		Navigator.of(context).push(MaterialPageRoute(
			builder: (context) => NewMessagePage()
		));
	}
}


class NewMessagePage extends StatelessWidget {
	final _subjectField = TextEditingController();
	final _contentField = TextEditingController();

	@override
	Widget build(BuildContext context) {
		return GestureDetector(
			onDoubleTap: () => _addMessage(context),
			child: Scaffold(
				body: Center(child: ListView(
					shrinkWrap: true,
					children: [
						TextField(
							controller: _subjectField,
							decoration: const InputDecoration(hintText: "Subject"),
						),
						TextField(
							controller: _contentField,
							decoration: const InputDecoration(hintText: "Content"),
						)
					]
				))
			)
		);
	}

	void _addMessage(BuildContext context) {
		final subject = _subjectField.text, content = _contentField.text;
		if (subject.isEmpty || content.isEmpty) return;

		Navigator.of(context).pop();
		Cloud.addMessage(
			subject: subject,
			content: content,
		);
	}
}
