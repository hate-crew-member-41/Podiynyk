import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:podiynyk/storage/appearance.dart';
import 'package:podiynyk/storage/cloud.dart';
import 'package:podiynyk/storage/entities/event.dart';
import 'package:podiynyk/storage/entities/student.dart' show Role;

import 'package:podiynyk/ui/main/common/fields.dart';

import 'entity.dart';


class EventPage extends HookWidget {
	const EventPage(this.event);

	final Event event;

	@override
	Widget build(BuildContext context) {
		final nameField = useTextEditingController(text: event.nameRepr);
		final date = useRef(event.date);
		final noteField = useTextEditingController();

		final hasDetails = useState(event.hasDetails);
		final showNote = useState(event.hasDetails && event.note != null);

		useEffect(() {
			event.addDetails().whenComplete(() {
				hasDetails.value = event.hasDetails;
				showNote.value = event.note != null;
				if (showNote.value) noteField.text = event.note!;
			});

			if (showNote.value) noteField.text = event.note!;

			return () {
				if (nameField.text != event.nameRepr) event.nameRepr = nameField.text;
				if (date.value != event.date) event.date = date.value;
				if (noteField.text != event.note) event.note = noteField.text;
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
				).withPadding(),
				DateField(
					initialDate: event.date,
					onPicked: (picked) => date.value = picked,
					enabled: Cloud.userRole != Role.ordinary
				),
				if (showNote.value) ...[
					const ListTile(),
					InputField(
						controller: noteField,
						name: "note",
						multiline: true,
						style: Appearance.bodyText
					)
				]
			],
			actions: [
				if (event.hasDetails && event.note == null) EntityActionButton(
					text: "add a note",
					action: () => showNote.value = true
				),
				!event.isHidden ? EntityActionButton(
					text: "hide",
					action: () => event.isHidden = true
				) : EntityActionButton(
					text: "show",
					action: () => event.isHidden = false
				),
				if (Cloud.userRole != Role.ordinary) EntityActionButton(
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
