import 'package:flutter/material.dart';

import 'package:podiynyk/storage/cloud.dart';
import 'package:podiynyk/storage/entities/event.dart';

import 'package:podiynyk/ui/main/common/fields.dart' show InputField;

import '../section.dart' show EntityDate;
import 'entity.dart';


class EventPage extends StatefulWidget {
	final Event event;

	const EventPage(this.event);

	@override
	State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
	late final Event _event;
	final _nameField = TextEditingController();
	final _noteField = TextEditingController();

	@override
	void initState() {
		_event = widget.event;
		_event.addDetails().whenComplete(() => setState(() {}));
		super.initState();
	}

	@override
	Widget build(BuildContext context) {
		final hasNote = _event.note != null;

		_nameField.text = _event.name;
		if (hasNote) _noteField.text = _event.note!;

		return EntityPage(
			children: [
				TextField(
					controller: _nameField,
					decoration: const InputDecoration(hintText: "name"),
					onSubmitted: _setLabel
				),
				if (_event.subjectName != null) Text(_event.subjectName!),
				Text(_event.date.fullRepr),  // todo: allow changing
				if (hasNote) TextField(
					controller: _noteField,
					decoration: const InputDecoration(hintText: "note"),
					onSubmitted: _setNote
				)
			],
			actions: [
				if (_event.note == null) EntityActionButton(
					text: "add a note",
					// todo: show the form on the event page instead?
					action: () => Navigator.of(context).push(MaterialPageRoute(
						builder: (_) => GestureDetector(
							onDoubleTap: _addNote,
							child: Scaffold(
								body: Center(child: InputField(
									controller: _noteField,
									name: "note"
								))
							)
						)
					))
				),
				_event.isShown ? EntityActionButton(
					text: "hide",
					action: _event.hide
				) : EntityActionButton(
					text: "show",
					action: _event.show
				),
				EntityActionButton(
					text: "delete",
					action: () => Cloud.deleteEvent(_event)
				)
			]
		);
	}

	void _setLabel(String label) {
		_event.label = label;
		if (label.isEmpty) _nameField.text = _event.name;
	}

	void _setNote(String note) {
		if (note.isNotEmpty) {
			_event.note = note;
			Cloud.updateEventNote(_event);
		}
		else {
			_noteField.text = _event.note!;
		}
	}

	void _addNote() {
		final note = _noteField.text;
		if (note.isEmpty) return;

		_event.note = note;
		Cloud.updateEventNote(_event);
		Navigator.of(context).pop();
	}
}
