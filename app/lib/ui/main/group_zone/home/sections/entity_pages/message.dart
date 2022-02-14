import 'package:flutter/material.dart';

import 'package:podiynyk/storage/cloud.dart' show Cloud;
import 'package:podiynyk/storage/local.dart';
import 'package:podiynyk/storage/entities/message.dart' show Message;

import '../section.dart' show EntityDate;
import 'entity.dart';


class MessagePage extends StatefulWidget {
	final Message message;

	const MessagePage(this.message);

	@override
	State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
	@override
	void initState() {
		widget.message.addDetails().whenComplete(() => setState(() {}));
		super.initState();
	}

	@override
	Widget build(BuildContext context) {
		final message = widget.message;
		final author = message.author;
		final content = message.content;

		return EntityPage(
			children: [
				Text(message.name),
				Text(message.date.fullRepr),
				if (author != null) Text("from $author"),
				if (content != null) Text(content)
			],
			actions: Local.name != message.author ? null : [EntityActionButton(
				text: "delete",
				action: () => Cloud.deleteMessage(message)
			)]
		);
	}
}
