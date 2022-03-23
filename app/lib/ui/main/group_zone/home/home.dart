import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'sections/agenda.dart';
import 'sections/non_subject_events.dart';
import 'sections/group.dart';
import 'sections/messages.dart';
import 'sections/section.dart';
import 'sections/subjects.dart';


final sectionProvider = StateProvider<Section>((ref) {
	return AgendaSection();
});


class Home extends ConsumerWidget {
	const Home();

	@override
	Widget build(BuildContext context, WidgetRef ref) {
		final section = ref.watch(sectionProvider);

		return Scaffold(
			appBar: AppBar(
				automaticallyImplyLeading: false,
				title: Row(
					mainAxisAlignment: MainAxisAlignment.spaceBetween,
					children: [
						Builder(builder: (context) => GestureDetector(
							child: Text(section.sectionName),
							onTap: () => Scaffold.of(context).openDrawer()
						)),
						Row(children: [
							// if (section.value is CloudEntitiesSection) Visibility(
							// 	visible: entityCount != null,
							// 	child: Text(entityCount.toString()).withPadding(),
							// ),
							Icon(section.sectionIcon)
						])
					]
				)
			),
			body: section,
			drawer: Drawer(
				child: Column(
					mainAxisAlignment: MainAxisAlignment.center,
					children: [
						_SectionTile(
							name: AgendaSection.name,
							icon: AgendaSection.icon,
							sectionBuilder: () => AgendaSection(),
						),
						_SectionTile(
							name: SubjectsSection.name,
							icon: SubjectsSection.icon,
							sectionBuilder: () => SubjectsSection(),
						),
						_SectionTile(
							name: NonSubjectEventsSection.name,
							icon: NonSubjectEventsSection.icon,
							sectionBuilder: () => NonSubjectEventsSection(),
						),
						const ListTile(),
						_SectionTile(
							name: MessagesSection.name,
							icon: MessagesSection.icon,
							sectionBuilder: () => MessagesSection(),
						),
						_SectionTile(
							name: GroupSection.name,
							icon: GroupSection.icon,
							sectionBuilder: () => GroupSection(),
						)
					]
				)
			),
			drawerEdgeDragWidth: 150,
			floatingActionButton: section.actionButton
		);
	}
}


class _SectionTile<S extends Section> extends ConsumerWidget {
	final String name;
	final IconData icon;
	final S Function() sectionBuilder;

	const _SectionTile({
		required this.name,
		required this.icon,
		required this.sectionBuilder,
	});

	@override
	Widget build(BuildContext context, WidgetRef ref) {
		return ListTile(
			title: Text(name),
			leading: Icon(icon),
			onTap: () {
				final section = ref.read(sectionProvider.notifier);

				if (section.state is! S) section.state = sectionBuilder();
				Navigator.of(context).pop();
			},	
			style: ListTileStyle.list
		);
	}
}
