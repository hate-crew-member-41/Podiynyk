import 'package:flutter/material.dart';

import 'package:podiynyk/storage/cloud.dart' show Cloud;
import 'package:podiynyk/storage/local.dart';
import 'package:podiynyk/storage/entities/message.dart' show Message;

import '../section.dart' show EntityDate;
import 'entity.dart';


class MessagePage extends StatefulWidget {
	final Message _message;

	const MessagePage(this._message);

	@override
	State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
	@override
	void initState() {
		widget._message.addDetails().whenComplete(() => setState(() {}));
		super.initState();
	}

	@override
	Widget build(BuildContext context) {
		final message = widget._message;
		final author = message.author;
		final content = message.content;

		return EntityPage(
			children: [
				Text(message.subject),
				Text(message.date.fullRepr),
				if (author != null) Text("from $author"),
				if (content != null) Text(content)
			],
			options: [Local.name != message.author ? EntityActionButton(
				text: "hide",
				action: () => Local.addHiddenEntity(StoredEntities.hiddenMessages, message)
			) : EntityActionButton(
				text: "delete",
				action: () => Cloud.deleteMessage(message)
			)]
		);
	}
}
