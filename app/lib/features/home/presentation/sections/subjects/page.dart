import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../domain/entities/info.dart';
import '../../../domain/entities/subject.dart';
import '../../../domain/providers/events.dart';

import '../../widgets/counted_icon.dart';
import '../events/list.dart';
import '../separate/info_list.dart';


class SubjectPage extends ConsumerWidget {
	const SubjectPage(this.subject);

	final Subject subject;

	@override
	Widget build(BuildContext context, WidgetRef ref) {
		const info = <Info>[];
		final events = ref.watch(eventsProvider)?.where((e) => e.subject == subject);

		return Scaffold(body: DefaultTabController(
			length: 2,
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
					TabBar(tabs: [
						Tab(child: CountedIcon(icon: Icons.notes, count: info.length)),
						Tab(child: CountedIcon(icon: Icons.event, count: events?.length))
					]),
					Expanded(
						child: TabBarView(children: [
						// Icon(Icons.notes),
						// Icon(Icons.event),
						const InfoList(info),
						EventsList(events)
						]),
					)
				]
			)
		));
	}
}
