import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:podiynyk/storage/appearance.dart';
import 'package:podiynyk/storage/cloud.dart';
import 'package:podiynyk/storage/entities/event.dart';
import 'package:podiynyk/storage/entities/student.dart' show Role;

import 'package:podiynyk/ui/main/common/fields.dart';

import 'entity.dart';


class EventPage extends HookWidget {
	final Event event;

	const EventPage(this.event);

	@override
	Widget build(BuildContext context) {
		final nameField = useTextEditingController(text: event.nameRepr);
		final showNoteField = useState(false);
		final noteField = useTextEditingController();

		useEffect(() {
			event.addDetails().whenComplete(() {
				final note = event.note;
				showNoteField.value = note != null;
				if (showNoteField.value) noteField.text = note!;
			});

			return () {
				event.label = nameField.text;
			
				final note = noteField.text;
				event.note = note.isNotEmpty ? note : null;
			};
		}, const []);

		return EntityPage(
			children: [
				InputField(
					controller: nameField,
					name: "name",
					style: Appearance.headlineText
				),
				if (event.subject != null) Text(
					event.subject!.nameRepr,
					style: Appearance.largeTitleText
				).withPadding,
				DateField(
					initialDate: event.date,
					onDatePicked: (date) => event.date = date,
					enabled: Cloud.role != Role.ordinary
				),
				if (showNoteField.value) ...[
					const ListTile(),
					InputField(
						controller: noteField,
						name: "note",
						isMultiline: true,
						style: Appearance.bodyText
					)
				]
			],
			actions: [
				if (event.note == null) EntityActionButton(
					text: "add a note",
					action: () => showNoteField.value = true
				),
				!event.isHidden ? EntityActionButton(
					text: "hide",
					action: () => event.isHidden = true
				) : EntityActionButton(
					text: "show",
					action: () => event.isHidden = false
				),
				if (Cloud.role != Role.ordinary) EntityActionButton(
					text: "delete",
					action: () => _delete(context)
				)
			]
		);
	}

	void _delete(BuildContext context) {
		Cloud.deleteEvent(event);
		Navigator.of(context).pop();
	}
}
