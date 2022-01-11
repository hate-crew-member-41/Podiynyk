import 'package:flutter/material.dart';

import 'package:podiynyk/storage/entities.dart' show Message;
import 'package:podiynyk/storage/local.dart';

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
		final author = widget._message.author;
		final content = widget._message.content;

		return GestureDetector(
			onLongPress: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => Scaffold(
				body: Align(
					alignment: Alignment.centerLeft,
					child: Local.name != widget._message.author ? TextButton(
							child: const Text("hide"),
							onPressed: () {},  // todo: implement
							style: const ButtonStyle(alignment: Alignment.centerLeft)
						) : TextButton(
							child: const Text("delete"),
							onPressed: () {},  // todo: implement
							style: const ButtonStyle(alignment: Alignment.centerLeft)
						)
				)
			))),
			child: Scaffold(
				body: Column(
					mainAxisAlignment: MainAxisAlignment.center,
					crossAxisAlignment: CrossAxisAlignment.start,
					children: [
						Text(widget._message.subject),
						Text(widget._message.date.fullRepr),
						if (author != null) Text("from $author"),
						if (content != null) Text(content)
					]
				)
			)
		);
	}
}
