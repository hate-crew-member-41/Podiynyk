import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'drawer_tile.dart';
import 'state.dart';

import 'sections/events/events.dart';
import 'sections/group/group.dart';
import 'sections/messages/messages.dart';
import 'sections/separate/separate.dart';
import 'sections/subjects/subjects.dart';


class Home extends ConsumerWidget {
	const Home();

	@override
	Widget build(BuildContext context, WidgetRef ref) {
		final section = ref.watch(homeStateProvider);
		final count = section.count(ref);

		return Scaffold(
			// think: make the whole AppBar available to tap on
			appBar: AppBar(
				automaticallyImplyLeading: false,
				title: Builder(builder: (context) => GestureDetector(
					onTap: () => Scaffold.of(context).openDrawer(),
					child: Text(section.name)
				)),
				actions: [
					if (count != null) Padding(
						// do: take from the theme
						padding: const EdgeInsets.only(right: 16),
						child: Center(child: Text(count.toString()))
					),
					Padding(
						// do: take from the theme
						padding: const EdgeInsets.only(right: 16),
						child: Icon(section.icon)
					)
				],
			),
			body: section,
			drawer: Drawer(child: Center(child: ListView(
				shrinkWrap: true,
				// do: arrange
				children: const [
					// think: show today's date instead
					Icon(Icons.all_inclusive),
					ListTile(),
					DrawerTile(EventsSection()),
					DrawerTile(SubjectsSection()),
					DrawerTile(SeparateSection()),
					ListTile(),
					DrawerTile(MessagesSection()),
					DrawerTile(GroupSection())
				]
			))),
			drawerEdgeDragWidth: 150
		);
	}
}
