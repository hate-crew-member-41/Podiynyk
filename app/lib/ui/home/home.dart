import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:podiynyk/storage/appearance.dart';

import 'sections/agenda.dart';
import 'sections/non_subject_events.dart';
import 'sections/group.dart';
import 'sections/messages.dart';
import 'sections/section.dart';
import 'sections/subjects.dart';


final sectionProvider = StateProvider<Section>((ref) {
	return const AgendaSection();
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
							child: Text(section.name),
							onTap: () => Scaffold.of(context).openDrawer()
						)),
						Row(children: [
							Consumer(builder: (_, ref, __) {
								final count = section is EntitiesSection ? section.countedEntities(ref)?.length : null;
								return Visibility(
									visible: count != null,
									child: Text(count.toString()).withPadding,
								);
							}),
							Icon(section.icon)
						])
					]
				)
			),
			body: section,
			drawer: Drawer(
				child: Column(
					mainAxisAlignment: MainAxisAlignment.center,
					children: const [
						_SectionTile(AgendaSection()),
						_SectionTile(SubjectsSection()),
						_SectionTile(NonSubjectEventsSection()),
						ListTile(),
						_SectionTile(MessagesSection()),
						_SectionTile(GroupSection())
					]
				)
			),
			drawerEdgeDragWidth: 150,
			floatingActionButton: section.actionButton
		);
	}
}


class _SectionTile extends ConsumerWidget {
	const _SectionTile(this.section);

	final Section section;

	@override
	Widget build(BuildContext context, WidgetRef ref) {
		return ListTile(
			leading: Icon(section.icon),
			title: Text(section.name),
			onTap: () {
				final sectionController = ref.read(sectionProvider.notifier);

				if (sectionController.state != section) {
					sectionController.state = section;
					if (section is EntitiesSection) (section as EntitiesSection).notifier(ref).update();
				}

				Navigator.of(context).pop();
			},
			style: ListTileStyle.list
		);
	}
}
