import 'package:flutter/material.dart';

import 'package:podiynyk/storage/entities.dart' show Message;

import '../section.dart' show EntityDate;


class MessagePage extends StatefulWidget {
	final Message _message;
	final _subjectField = TextEditingController();

	MessagePage(this._message) {
		_subjectField.text = _message.subject;
	}

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
			onLongPress: () {},  // todo: the options
			child: Scaffold(
				body: Column(
					mainAxisAlignment: MainAxisAlignment.center,
					crossAxisAlignment: CrossAxisAlignment.start,
					children: [
						TextField(  // todo: adding a label
							controller: widget._subjectField,
							decoration: const InputDecoration(hintText: "subject"),
						),
						Text(widget._message.date.fullRepr),
						if (author != null) Text("from $author"),
						if (content != null) Text(content)
					]
				)
			)
		);
	}
}
