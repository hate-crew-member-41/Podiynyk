import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:podiinyk/core/domain/types/date.dart';
import 'package:podiinyk/core/domain/user/state.dart';

import '../../../domain/entities/entity.dart';
import '../../../domain/entities/event.dart';
import '../../../domain/entities/subject.dart';
import '../../../domain/providers/events.dart';
import '../../../domain/providers/subjects.dart';

import '../../widgets/fields/date_field.dart';
import '../../widgets/fields/option_field.dart';


// fix: an error screen appears for a moment the first time the form is opened
// 		EventForm relies on subjectsProvider to have been accessed
//		EventsPage reads events from HomeRepository, not subjectsProvider
// 		fix this after the data layer is improved
// do: TextField.(textInputType, multiline, textInputAction)
// think: define EntityForm
class EventForm extends HookConsumerWidget {
	const EventForm();

	@override
	Widget build(BuildContext context, WidgetRef ref) {
		final user = ref.watch(userProvider);
		final subjects = ref.watch(subjectsProvider)!.where((s) => user.studies(s));

		final nameField = useTextEditingController();
		final subject = useRef<Subject?>(null);
		final date = useRef<Date?>(null);
		final noteField = useTextEditingController();

		return GestureDetector(
			onDoubleTap: () => _handleAdd(
				context,
				ref,
				nameField.text,
				subject.value,
				date.value,
				noteField.text
			),
			child: Scaffold(body: Column(
				mainAxisAlignment: MainAxisAlignment.center,
				children: [
					TextField(
						controller: nameField,
						decoration: const InputDecoration(labelText: 'name')
					),
					if (subjects.isNotEmpty) OptionField<Subject>(
						label: 'subject',
						options: [
							for (final subject in subjects)
								MapEntry(subject.name, subject)
						],
						onPick: (s) => subject.value = s,
						isRequired: false
					),
					DateField(onPick: (d) => date.value = d),
					TextField(
						controller: noteField,
						decoration: const InputDecoration(labelText: 'note')
					)
				]
			))
		);
	}

	void _handleAdd(
		BuildContext context,
		WidgetRef ref,
		String name,
		Subject? subject,
		Date? date,
		String note
	) {
		// do: inform the user
		if (name.isEmpty || date == null) return;

		// think: await to show success or a failure
		ref.read(eventsProvider.notifier).add(Event(
			id: Entity.newId(),
			name: name,
			subject: subject,
			date: date,
			note: note.isEmpty ? null : note
		));
		Navigator.of(context).pop();
	}
}
