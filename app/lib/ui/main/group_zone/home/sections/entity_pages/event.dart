import 'package:flutter/material.dart';

import 'package:podiynyk/storage/cloud.dart';
import 'package:podiynyk/storage/entities/event.dart';

import 'package:podiynyk/ui/main/widgets/fields.dart' show InputField;

import '../section.dart' show EntityDate;
import 'entity.dart';


class EventPage extends StatefulWidget {
	final Event event;

	const EventPage(this.event);

	@override
	State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
	final _nameField = TextEditingController();
	final _noteField = TextEditingController();

	@override
	void initState() {
		widget.event.addDetails().whenComplete(() => setState(() {}));
		super.initState();
	}

	@override
	Widget build(BuildContext context) {
		final event = widget.event;
		final subjectName = event.subjectName;
		final note = event.note;
		final hasNote = note != null;

		_nameField.text = event.name;
		if (hasNote) _noteField.text = note;

		return EntityPage(
			children: [
				TextField(
					controller: _nameField,
					decoration: const InputDecoration(hintText: "name"),
					onSubmitted: (label) {},  // todo: add the label
				),
				if (subjectName != null) Text(subjectName),
				Text(event.date.fullRepr),  // todo: allow changing
				if (hasNote) TextField(
					controller: _noteField,
					decoration: const InputDecoration(hintText: "to be deleted"),
					onSubmitted: (newNote) {},  // todo: update the note
				)
			],
			actions: [
				if (event.note == null) EntityActionButton(
					text: "add a note",
					action: () => Navigator.of(context).push(MaterialPageRoute(
						builder: (_) => GestureDetector(
							onDoubleTap: addNote,
							child: Scaffold(
								body: Center(child: InputField(
									controller: _noteField,
									name: "note"
								))
							)
						)
					))
				),
				event.isShown ? EntityActionButton(
					text: "hide",
					action: event.hide
				) : EntityActionButton(
					text: "show",
					action: event.show
				),
				EntityActionButton(
					text: "delete",
					action: () => Cloud.deleteEvent(event)
				)
			]
		);
	}

	void addNote() {
		widget.event.note = _noteField.text;
		Cloud.updateEventNote(widget.event);
		Navigator.of(context).pop();
	}
}
