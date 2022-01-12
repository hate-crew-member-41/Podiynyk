import 'package:flutter/material.dart';

import 'package:podiynyk/storage/entities/event.dart' show Event;

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
			onLongPress: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => Scaffold(
				body: Column(
				mainAxisAlignment: MainAxisAlignment.center,
				crossAxisAlignment: CrossAxisAlignment.start,
				children: [
					TextButton(
						child: const Text("add a note"),
						onPressed: () {},  // todo: implement
						style: const ButtonStyle(alignment: Alignment.centerLeft)
					),
					// todo: implement the queues feature, add (schedule / start, delete) buttons
					TextButton(
						child: const Text("hide"),
						onPressed: () {},  // todo: implement
						style: const ButtonStyle(alignment: Alignment.centerLeft)
					),
					TextButton(
						child: const Text("delete"),
						onPressed: () {},  // todo: implement
						style: const ButtonStyle(alignment: Alignment.centerLeft)
					)
				]
			)
			))),
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
