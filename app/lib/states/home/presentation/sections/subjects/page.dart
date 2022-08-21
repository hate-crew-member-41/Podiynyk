import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:podiinyk/core/domain/user/state.dart';

import '../../../domain/entities/subject.dart';
import '../../../domain/providers/events.dart';
import '../../../domain/providers/subjects.dart';

import '../../state.dart';

import '../../widgets/bars/action_bar.dart';
import '../../widgets/bars/action_button.dart';
import '../../widgets/bars/counted_icon.dart';
import '../../widgets/bars/entity_lists_tab_bar.dart';
import '../../widgets/info/list.dart';

import '../events/list.dart';
import '../groupmates/list.dart';


class SubjectPage extends ConsumerWidget {
	const SubjectPage(this.subject);

	final Subject subject;

	@override
	Widget build(BuildContext context, WidgetRef ref) {
		final user = ref.watch(userProvider);
		final details = ref.watch(subjectDetailsFamily(subject));
		final events = ref.watch(eventsProvider)?.where((e) => e.subject == subject);

		final isCommon = subject.isCommon;
		final isStudied = user.studies(subject);
		final students = details?.students;

		return ScaffoldMessenger(child: Scaffold(body: DefaultTabController(
			length: isCommon ? 2 : 3,
			child: Column(
				crossAxisAlignment: CrossAxisAlignment.start,
				children: [
					SafeArea(child: ActionBar(children: [
						if (!isCommon) ActionButton(
							icon: isStudied ?
								Icons.local_library :
								Icons.hotel,
							// do: inform about the Future
							action: () => ref.read(userProvider.notifier).toggleSubjectIsStudied(subject)
						),
						Builder(builder: (context) => ActionButton(
							icon: Icons.delete,
							action: () => _showDeletingOptions(context, ref)
						))
					])),
					Text(subject.name),
					EntityListsTabBar(tabIcons: [
						CountedIcon(
							icon: Icons.notes,
							count: details?.info.length
						),
						CountedIcon(
							icon: Section.events.icon,
							count: events?.length
						),
						if (!isCommon) CountedIcon(
							icon: Icons.people,
							count: students?.length
						)
					]),
					Expanded(child: TabBarView(children: [
						InfoList(
							details?.info,
							subject: subject,
							isExtendable: isStudied
						),
						EventList(
							events,
							isExtendable: isStudied,
							showSubjects: false
						),
						if (!isCommon) GroupmateList(students)
					]))
				]
			)
		)));
	}

	// think: turn the "clear" option to "delete multiple"
	void _showDeletingOptions(BuildContext context, WidgetRef ref) {
		final snackBar = SnackBar(content: Row(
			mainAxisAlignment: MainAxisAlignment.spaceAround,
			children: [
				IconButton(
					icon: const Icon(Icons.delete),
					onPressed: () => _delete(context, ref)
				),
				IconButton(
					icon: const Icon(Icons.delete_sweep),
					onPressed: () => _clear(context, ref)
				)
			]
		));
		ScaffoldMessenger.of(context).showSnackBar(snackBar);
	}

	void _delete(BuildContext context, WidgetRef ref) {
		// think: await
		ref.read(subjectsProvider.notifier).delete(subject);
		Navigator.of(context).pop();
	}

	void _clear(BuildContext context, WidgetRef ref) {
		// think: await
		ref.read(subjectsProvider.notifier).clear();
		Navigator.of(context).pop();
	}
}
