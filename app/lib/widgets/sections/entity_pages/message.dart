import 'package:flutter/material.dart';

import 'package:podiynyk/storage/cloud.dart' show Cloud;
import 'package:podiynyk/storage/local.dart';
import 'package:podiynyk/storage/entities/message.dart' show Message;

import '../section.dart' show EntityDate;


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

		return GestureDetector(
			onLongPress: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => Scaffold(
				body: Align(
					alignment: Alignment.centerLeft,
					child: Local.name != message.author ? TextButton(
							child: const Text("hide"),
							onPressed: () => Local.addHiddenMessage(message.subject),
							style: const ButtonStyle(alignment: Alignment.centerLeft)
						) : TextButton(
							child: const Text("delete"),
							onPressed: () => Cloud.deleteMessage(message),
							style: const ButtonStyle(alignment: Alignment.centerLeft)
						)
				)
			))),
			child: Scaffold(
				body: Column(
					mainAxisAlignment: MainAxisAlignment.center,
					crossAxisAlignment: CrossAxisAlignment.start,
					children: [
						Text(message.subject),
						Text(message.date.fullRepr),
						if (author != null) Text("from $author"),
						if (content != null) Text(content)
					]
				)
			)
		);
	}
}
