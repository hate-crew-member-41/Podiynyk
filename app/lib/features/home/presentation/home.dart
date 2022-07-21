import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'widgets/drawer_tile.dart';
import 'state.dart';

import 'sections/events/section.dart';
import 'sections/students/section.dart';
import 'sections/messages/section.dart';
import 'sections/separate/section.dart';
import 'sections/subjects/section.dart';


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
				// do: take the values from the theme
				children: const [
					// think: show today's date instead
					Icon(Icons.all_inclusive),
					SizedBox(height: 56),
					DrawerTile(EventsSection()),
					DrawerTile(SubjectsSection()),
					DrawerTile(SeparateSection()),
					SizedBox(height: 56),
					DrawerTile(MessagesSection()),
					DrawerTile(StudentsSection())
				]
			))),
			drawerEdgeDragWidth: 80
		);
	}
}
