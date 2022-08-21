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
				children: const [
					Icon(Icons.all_inclusive),
					DrawerTile(Section.events),
					DrawerTile(Section.subjects),
					DrawerTile(Section.separate),
					DrawerTile(Section.messages),
					DrawerTile(Section.groupmates),
					DrawerTile(Section.settings),
				]
			))),
			drawerEdgeDragWidth: 80
		);
	}
}
