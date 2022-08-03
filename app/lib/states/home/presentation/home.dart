import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'state.dart';
import 'widgets/tiles/drawer_tile.dart';

// do: remove
import 'package:firebase_auth/firebase_auth.dart';
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
				children: [
					// think: show today's date instead
					const Icon(Icons.all_inclusive),
					const SizedBox(height: 56),
					const DrawerTile(Section.events),
					const DrawerTile(Section.subjects),
					const DrawerTile(Section.separate),
					const SizedBox(height: 56),
					const DrawerTile(Section.messages),
					const DrawerTile(Section.students),
					// do: remove
					const SizedBox(height: 56),
					ListTile(
						leading: const Icon(Icons.business),
						title: const Text("leave"),
						onTap: () async {
							await ref.read(userProvider.notifier).leave();
							ref.read(appStateProvider.notifier).state = AppState.identification;
						}
					),
					ListTile(
						leading: const Icon(Icons.compare_arrows),
						title: const Text("sign out"),
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
