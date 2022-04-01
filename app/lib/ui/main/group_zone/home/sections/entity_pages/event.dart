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
	const EventPage(this.initial);

	final Event initial;

	@override
	Widget build(BuildContext context, WidgetRef ref) {
		final event = useState(initial);
		final nameField = useTextEditingController(text: initial.nameRepr);
		final date = useRef(initial.date);
		final noteField = useTextEditingController(text: initial.note);

		useEffect(() {
			if (!initial.hasDetails) initial.withDetails.then((withDetails) {
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
				if (initial.subject != null) Text(
					initial.subject!.nameRepr,
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
			onClose: () {
				final current = Event.modified(
					event: event.value,
					nameRepr: nameField.text,
					date: date.value,
					note: noteField.text
				);

				if (current.nameRepr != initial.nameRepr || current.date != initial.date) {
					ref.read(eventsNotifierProvider.notifier).replace(initial, current, preserveState: false);
				}
				else if (current.hasDetails && (!initial.hasDetails || current.note != initial.note)) {
					ref.read(eventsNotifierProvider.notifier).replace(initial, current);
				}
			}
		);
	}

	// void _delete(BuildContext context, WidgetRef ref) {
	// 	event.delete();
	// 	Navigator.of(context).pop();
	// 	(ref.read(sectionProvider) as EntitiesSection).update(ref);
	// }
}
