import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../domain/entities/info.dart';
import '../../../domain/entities/student.dart';
import '../../../domain/entities/subject.dart';
import '../../../domain/providers/events.dart';

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
		const info = <Info>[];
		final events = ref.watch(eventsProvider)?.where((e) => e.subject == subject);
		const students = <Student>[];

		final isCommon = subject.isCommon;

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
									child: Icon(Icons.visibility),
								),
								Padding(
									padding: EdgeInsets.only(right: 16),
									child: Icon(Icons.edit),
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
						CountedIcon(icon: Icons.notes, count: info.length),
						CountedIcon(icon: Icons.event, count: events?.length),
						if (!isCommon) CountedIcon(icon: Icons.people, count: subject.students!.length)
					]),
					Expanded(child: TabBarView(children: [
						const InfoList(info),
						EventsList(events),
						if (!isCommon) const StudentList(students)
					]))
				]
			)
		));
	}
}
