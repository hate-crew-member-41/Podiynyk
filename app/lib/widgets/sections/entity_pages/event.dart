import 'package:flutter/material.dart';

import 'package:podiynyk/storage/cloud.dart' show Cloud;
import 'package:podiynyk/storage/local.dart';
import 'package:podiynyk/storage/entities/event.dart' show Event;

import '../section.dart' show EntityDate;
import 'entity.dart';


class EventPage extends StatefulWidget {
	final Event _event;
	final _nameField = TextEditingController();
	final _noteField = TextEditingController();

	EventPage(this._event);

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
		final hasNote = note != null;

		widget._nameField.text = widget._event.name;
		if (hasNote) widget._noteField.text = note;

		return EntityPage(
			children: [
				TextField(
					controller: widget._nameField,
					decoration: const InputDecoration(hintText: "name"),
					onSubmitted: (label) {},  // todo: add the label
				),
				if (subject != null) Text(subject),
				Text(widget._event.date.fullRepr),  // todo: allow changing
				if (hasNote) TextField(
					controller: widget._noteField,
					decoration: const InputDecoration(hintText: "note"),
					onSubmitted: (newNote) {},  // todo: change the note
				)
			],
			options: [
				if (widget._event.note == null) EntityActionButton(
					text: "add a note",
					action: () {}  // todo: implement
				),
				// todo: implement the queues feature, add (schedule / start, delete) buttons
				EntityActionButton(
					text: "hide",
					action: () => Local.addHiddenEntity(StoredEntities.hiddenEvents, widget._event)
				),
				EntityActionButton(
					text: "delete",
					action: () => Cloud.deleteEvent(widget._event)
				)
			]
		);
	}
}
