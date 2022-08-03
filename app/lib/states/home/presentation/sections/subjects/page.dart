import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:podiinyk/core/domain/user/state.dart';

import '../../../domain/entities/subject.dart';
import '../../../domain/providers/events.dart';
import '../../../domain/providers/subjects.dart';

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
		final details = ref.watch(subjectDetailsProviders(subject));
		final events = ref.watch(eventsProvider)?.where((e) => e.subject == subject);

		final isCommon = subject.isCommon;
		final isStudied = user.studies(subject);
		final students = details?.students;

		return Scaffold(body: DefaultTabController(
			length: isCommon ? 2 : 3,
			child: Column(
				crossAxisAlignment: CrossAxisAlignment.start,
				children: [
					SafeArea(child: ActionBar(children: [
						// do: inform about the Future
						// think: wrap in a Consumer of the userProvider
						if (!isCommon) ActionButton(
							icon: isStudied ?
								Icons.local_library :
								Icons.airline_seat_individual_suite,
							action: () => _setIsStudied(ref, !isStudied)
						),
						ActionButton(
							icon: Icons.delete,
							action: () => _delete(context, ref)
						)
					])),
					Text(subject.name),
					EntityListsTabBar(tabIcons: [
						CountedIcon(
							icon: Icons.notes,
							count: details?.info.length
						),
						CountedIcon(
							icon: Icons.event,
							count: events?.length
						),
						if (!isCommon) CountedIcon(
							icon: Icons.people,
							count: students?.length
						)
					]),
					// think: wrap in a Consumer of the userProvider
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
		));
	}

	void _setIsStudied(WidgetRef ref, bool isStudied) {
		final userNotifier = ref.read(userProvider.notifier);

		if (isStudied) {
			userNotifier.setStudied(subject);
		}
		else {
			userNotifier.setUnstudied(subject);
		}
	}

	// do: confirmation, rename
	void _delete(BuildContext context, WidgetRef ref) {
		ref.read(subjectsProvider.notifier).delete(subject);
		Navigator.of(context).pop();
	}
}
