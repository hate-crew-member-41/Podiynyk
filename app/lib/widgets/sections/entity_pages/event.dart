import 'package:flutter/material.dart';

import 'package:podiynyk/storage/entities.dart' show Event;

import '../section.dart' show EntityDate;


// todo: make entity pages share code
class EventPage extends StatefulWidget {
	final Event _event;
	final _nameField = TextEditingController();

	EventPage(this._event) {
		_nameField.text = _event.name;
	}

	@override
	State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
	@override
	void initState() {
		widget._event.addDetails().whenComplete(() => setState(() {}));
		super.initState();
	}

	@override
	Widget build(BuildContext context) {
		final subject = widget._event.subject;
		final note = widget._event.note;

		return GestureDetector(
			onLongPress: () {},  // todo: the options
			child: Scaffold(
				body: Column(
					mainAxisAlignment: MainAxisAlignment.center,
					crossAxisAlignment: CrossAxisAlignment.start,
					children: [
						TextField(
							controller: widget._nameField,
							decoration: const InputDecoration(hintText: "name"),
							onSubmitted: (label) {},  // todo: add the label
						),
						if (subject != null) Text(subject),
						Text(widget._event.date.fullRepr),
						if (note != null) Text(note)
					]
				)
			)
		);
	}
}
