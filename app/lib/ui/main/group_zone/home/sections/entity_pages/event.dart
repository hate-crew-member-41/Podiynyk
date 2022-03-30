import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:podiynyk/storage/appearance.dart';
import 'package:podiynyk/storage/cloud.dart';
import 'package:podiynyk/storage/entities/event.dart';
import 'package:podiynyk/storage/entities/student.dart' show Role;

import 'package:podiynyk/ui/main/widgets/input_field.dart';
import 'package:podiynyk/ui/main/widgets/date_field.dart';

import '../providers.dart' show eventsNotifierProvider;
import 'entity.dart';


class EventPage extends HookConsumerWidget {
	const EventPage(this.initialEvent);

	final Event initialEvent;

	@override
	Widget build(BuildContext context, WidgetRef ref) {
		final event = useState(initialEvent);
		final nameField = useTextEditingController(text: initialEvent.nameRepr);
		final date = useRef(initialEvent.date);
		final noteField = useTextEditingController(text: initialEvent.note);

		useEffect(() {
			if (!initialEvent.hasDetails) initialEvent.withDetails.then((withDetails) {
				ref.read(eventsNotifierProvider.notifier).replace(event.value, withDetails, preserveState: true);
				event.value = withDetails;
				if (withDetails.note != null) noteField.text = withDetails.note!;
			});

			return null;
		}, const []);

		return EntityPage(
			children: [
				InputField(
					controller: nameField,
					name: "name",
					style: Appearance.headlineText
				),
				if (initialEvent.subject != null) Text(
					initialEvent.subject!.nameRepr,
					style: Appearance.largeTitleText
				).withPadding(),
				DateField(
					initialDate: event.value.date,
					onPicked: (picked) => date.value = picked,
					enabled: Cloud.userRole != Role.ordinary
				),
				if (event.value.note != null) ...[
					const ListTile(),
					InputField(
						controller: noteField,
						name: "note",
						multiline: true,
						style: Appearance.bodyText
					)
				]
			],
			// actions: [
			// 	if (event.hasDetails && event.note == null) EntityActionButton(
			// 		text: "add a note",
			// 		action: () => showNote.value = true
			// 	),
			// 	!event.isHidden ? EntityActionButton(
			// 		text: "hide",
			// 		action: () => event.isHidden = true
			// 	) : EntityActionButton(
			// 		text: "show",
			// 		action: () => event.isHidden = false
			// 	),
			// 	if (Cloud.userRole != Role.ordinary) EntityActionButton(
			// 		text: "delete",
			// 		action: () => _delete(context, ref)
			// 	)
			// ],
			// sectionShouldRebuild: () {
			// 	bool changed = false;

			// 	if (nameField.text != event.nameRepr) {
			// 		event.nameRepr = nameField.text;
			// 		changed = true;
			// 	}
			// 	if (date.value != event.date) {
			// 		event.date = date.value;
			// 		changed = true;
			// 	}

			// 	final note = noteField.text.isNotEmpty ? noteField.text : null;
			// 	if (note != event.note) event.note = note;

			// 	return changed;
			// },
		);
	}

	// void _delete(BuildContext context, WidgetRef ref) {
	// 	event.delete();
	// 	Navigator.of(context).pop();
	// 	(ref.read(sectionProvider) as EntitiesSection).update(ref);
	// }
}
