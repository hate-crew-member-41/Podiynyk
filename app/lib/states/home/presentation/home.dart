import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'state.dart';
import 'widgets/tiles/drawer_tile.dart';

// do: remove
import 'package:podiinyk/core/domain/user/state.dart';
import 'package:podiinyk/main.dart';


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
