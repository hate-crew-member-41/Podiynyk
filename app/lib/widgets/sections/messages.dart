import 'package:flutter/material.dart';

import 'package:podiynyk/storage/cloud.dart' show Cloud;

import 'section.dart';


class MessagesSection extends Section {
	@override
	final name = "messages";
	@override
	final icon = Icons.messenger;
	@override
	final hasAddAction = true;

	const MessagesSection();

	@override
	Widget build(BuildContext context) {
		return Center(child: Icon(icon));
	}

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
		if (_subjectField.text.isEmpty || _contentField.text.isEmpty) return;
		Navigator.of(context).pop();
		// Cloud.addMessage(
		// 	subject: _subjectField.text,
		// 	content: _contentField.text
		// );
	}
}
