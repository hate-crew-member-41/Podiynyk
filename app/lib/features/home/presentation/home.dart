import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:podiinyk/main.dart';

import 'sections/events/section.dart';
import 'sections/students/section.dart';
import 'sections/messages/section.dart';
import 'sections/separate/section.dart';
import 'sections/subjects/section.dart';

import 'widgets/tiles/drawer_tile.dart';
import 'state.dart';


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
				children: [
					// think: show today's date instead
					const Icon(Icons.all_inclusive),
					const SizedBox(height: 56),
					const DrawerTile(EventsSection()),
					const DrawerTile(SubjectsSection()),
					const DrawerTile(SeparateSection()),
					const SizedBox(height: 56),
					const DrawerTile(MessagesSection()),
					const DrawerTile(StudentsSection()),
					// do: remove
					ListTile(
						title: const Text('sign out'),
						onTap: () async {
							await FirebaseAuth.instance.signOut();
							ref.read(appStateProvider.notifier).state = AppState.auth;
						}
					)
				]
			))),
			drawerEdgeDragWidth: 80
		);
	}
}
