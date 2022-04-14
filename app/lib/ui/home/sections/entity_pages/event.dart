import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:podiynyk/storage/appearance.dart';
import 'package:podiynyk/storage/cloud.dart';
import 'package:podiynyk/storage/identifier.dart';
import 'package:podiynyk/storage/local.dart';
import 'package:podiynyk/storage/entities/event.dart';
import 'package:podiynyk/storage/entities/student.dart' show Role;

import 'package:podiynyk/ui/widgets/input_field.dart';
import 'package:podiynyk/ui/widgets/date_field.dart';

import '../providers.dart' show eventsNotifierProvider;
import 'entity.dart';


class EventPage extends HookConsumerWidget {
	EventPage(this.initial) :
		userIsOrdinary = Local.userRole == Role.ordinary;

	final Event initial;
	final bool userIsOrdinary;

	@override
	Widget build(BuildContext context, WidgetRef ref) {
		final event = useState(initial);
		final nameField = useTextEditingController(text: initial.nameRepr);
		final date = useRef(initial.date);
		final hidden = useRef(initial.isHidden);
		final noteField = useTextEditingController(text: initial.note);

		final showNote = useState(initial.note != null);

		useEffect(() {
			if (!initial.hasDetails) initial.withDetails.then((withDetails) {
				event.value = withDetails;

				if (withDetails.note != null) {
					noteField.text = withDetails.note!;
					showNote.value = true;
				}
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
				if (initial.subject != null)
					Text(
						initial.subject!.nameRepr,
						style: Appearance.largeTitleText
					).withPadding,
				DateField(
					initialDate: event.value.date,
					onPicked: (picked) => date.value = picked,
					enabled: Local.userRole != Role.ordinary
				),
				if (showNote.value)
					...[
						const ListTile(),
						InputField(
							controller: noteField,
							name: "note",
							multiline: true,
							style: Appearance.bodyText
						)
					]
			],
			actions: () => [
				if (event.value.hasDetails && !showNote.value)
					EntityActionButton(
						text: "add a note",
						action: () => showNote.value = true
					),
				!hidden.value ?
					EntityActionButton(
						text: "hide",
						action: () => hidden.value = true
					) :
					EntityActionButton(
						text: "show",
						action: () => hidden.value = false
					),
				if (!userIsOrdinary)
					EntityActionButton(
						text: "delete",
						action: () => _delete(context, ref, event.value)
					)
			],
			onClose: () => _onClose(ref, event.value, nameField.text, date.value, hidden.value, noteField.text)
		);
	}

	void _delete(BuildContext context, WidgetRef ref, Event event) {
		Cloud.deleteEntity(event);
		Navigator.of(context).pop();
		ref.read(eventsNotifierProvider.notifier).update();
	}

	void _onClose(WidgetRef ref, Event current, String nameRepr, DateTime date, bool hidden, String note) {
		final updated = Event.modified(
			event: current,
			nameRepr: nameRepr,
			date: date,
			hidden: hidden,
			note: note
		);

		bool changed = false;

		if (updated.date != current.date) {
			Cloud.updateEntity(updated);
			changed = true;
		}

		if (updated.isHidden != current.isHidden) {
			if (updated.isHidden) {
				Local.storeEntity(Identifier.hiddenEvents, updated);
			}
			else {
				Local.deleteEntity(Identifier.hiddenEvents, updated);
			}

			changed = true;
		}

		if (updated.hasDetails) {
			if (!initial.hasDetails) changed = true;

			if (updated.note != current.note) {
				Cloud.updateEntityDetails(updated);
				changed = true;
			}
		}

		if (changed) {
			ref.read(eventsNotifierProvider.notifier).updateEntity(updated);
		}
	}
}
