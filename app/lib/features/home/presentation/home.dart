import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'widgets/drawer_tile.dart';
import 'state.dart';

import 'sections/events/events.dart';
import 'sections/students/students.dart';
import 'sections/messages/messages.dart';
import 'sections/separate/separate.dart';
import 'sections/subjects/subjects.dart';


class Home extends ConsumerWidget {
	const Home();

	@override
	Widget build(BuildContext context, WidgetRef ref) {
		final section = ref.watch(homeStateProvider);

		return Scaffold(
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
					DrawerTile(StudentsSection())
				]
			))),
			drawerEdgeDragWidth: 80
		);
	}
}
