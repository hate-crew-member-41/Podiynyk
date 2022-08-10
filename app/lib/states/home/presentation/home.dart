import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'widgets/tiles/drawer_tile.dart';
import 'state.dart';


class Home extends ConsumerWidget {
	const Home();

	@override
	Widget build(BuildContext context, WidgetRef ref) {
		return Scaffold(
			body: ref.watch(homeStateProvider).widget,
			drawer: Drawer(child: Center(child: ListView(
				shrinkWrap: true,
				// do: arrange
				// do: take the values from the theme
				children: const [
					// think: show today's date instead
					Icon(Icons.all_inclusive),
					SizedBox(height: 56),
					DrawerTile(Section.events),
					DrawerTile(Section.subjects),
					DrawerTile(Section.separate),
					DrawerTile(Section.messages),
					SizedBox(height: 56),
					DrawerTile(Section.students),
					DrawerTile(Section.settings),
				]
			))),
			drawerEdgeDragWidth: 80
		);
	}
}
