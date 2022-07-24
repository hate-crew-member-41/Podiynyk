import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../domain/entities/student.dart';
import '../../../domain/entities/subject.dart';
import '../../../domain/providers/events.dart';
import '../../../domain/providers/subjects.dart';

import '../../widgets/counted_icon.dart';
import '../../widgets/entity_lists_tab_bar.dart';

import '../events/list.dart';
import '../separate/info_list.dart';
import '../students/list.dart';


class SubjectPage extends ConsumerWidget {
	const SubjectPage(this.subject);

	final Subject subject;

	@override
	Widget build(BuildContext context, WidgetRef ref) {
		final info = ref.watch(subjectInfoProvider(subject));
		final events = ref.watch(eventsProvider)?.where((e) => e.subject == subject);
		const students = <Student>[];

		final isCommon = subject.isCommon;
		final isStudied = subject.isStudied;

		return Scaffold(body: DefaultTabController(
			length: isCommon ? 2 : 3,
			child: Column(
				crossAxisAlignment: CrossAxisAlignment.start,
				children: [
					SizedBox(
						// do: take from the theme
						height: 56,
						child: Row(
							mainAxisAlignment: MainAxisAlignment.end,
							children: const [
								Padding(
									padding: EdgeInsets.only(right: 16),
									child: Icon(Icons.visibility)
								),
								Padding(
									padding: EdgeInsets.only(right: 16),
									child: Icon(Icons.edit)
								),
								Padding(
									padding: EdgeInsets.only(right: 16),
									child: Icon(Icons.delete)
								)
							]
						)
					),
					Text(subject.name),
					EntityListsTabBar(tabIcons: [
						CountedIcon(
							icon: Icons.notes,
							count: info?.length
						),
						CountedIcon(
							icon: Icons.event,
							count: events?.length
						),
						if (!isCommon) CountedIcon(
							icon: Icons.people,
							count: subject.students!.length
						)
					]),
					Expanded(child: TabBarView(children: [
						InfoList(
							info,
							subject: subject,
							isExtendable: isStudied
						),
						EventList(
							events,
							isExtendable: isStudied,
							showSubjects: false
						),
						if (!isCommon) const StudentList(students)
					]))
				]
			)
		));
	}
}
