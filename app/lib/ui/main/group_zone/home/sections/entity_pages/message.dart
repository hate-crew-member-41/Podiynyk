import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:podiynyk/storage/appearance.dart';
import 'package:podiynyk/storage/cloud.dart';
import 'package:podiynyk/storage/local.dart';
import 'package:podiynyk/storage/entities/date.dart';
import 'package:podiynyk/storage/entities/message.dart';

import 'package:podiynyk/ui/main/common/fields.dart' show InputField;

import 'entity.dart';


class MessagePage extends StatefulWidget {
	final Message message;

	const MessagePage(this.message);

	@override
	State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
	late final Message _message;
	final _nameField = TextEditingController();
	final _contentField = TextEditingController();

	@override
	void initState() {
		super.initState();
		_message = widget.message;
		_nameField.text = _message.name;
		_message.addDetails().whenComplete(() => setState(() {}));
	}

	@override
	Widget build(BuildContext context) {
		final author = _message.author;
		final isAuthor = author.name == Local.name;

		final content = _message.content;
		final hasContent = content != null;
		if (hasContent) _contentField.text = content;

		return EntityPage(
			children: [
				InputField(
					controller: _nameField,
					name: "topic",
					enabled: isAuthor,
					style: Appearance.headlineText
				),
				if (hasContent) InputField(
					controller: _contentField,
					name: "content",
					grows: true,
					enabled: isAuthor,
					style: Appearance.bodyText
				),
				const ListTile(),
				Text(
					author.nameRepr,
					style: Appearance.bodyText
				).withPadding,
				Text(
					_message.date.fullRepr,
					style: Appearance.bodyText
				).withPadding,

				// InputField(
				// 	controller: _nameField,
				// 	name: "topic",
				// 	enabled: isAuthor,
				// 	style: Appearance.headlineText
				// ),
				// Text(
				// 	"from ${author.nameRepr}",
				// 	style: Appearance.largeTitleText
				// ).withPadding,
				// Text(
				// 	_message.date.fullRepr,
				// 	style: Appearance.titleText
				// ).withPadding,
				// const ListTile(),
				// if (hasContent) InputField(
				// 	controller: _contentField,
				// 	name: "content",
				// 	grows: true,
				// 	enabled: isAuthor,
				// 	style: Appearance.bodyText
				// ),
			],
			actions: [
				if (isAuthor) EntityActionButton(
					text: "delete",
					action: () => _delete(context)
				)
			]
		);
	}

	void _delete(BuildContext context) {
		Cloud.deleteMessage(_message);
		Navigator.of(context).pop();
	}

	@override
	void dispose() {
		final name = _nameField.text;
		if (name.isNotEmpty) _message.name = name;

		final content = _contentField.text;
		if (content.isNotEmpty) _message.content = content;

		super.dispose();
	}
}
