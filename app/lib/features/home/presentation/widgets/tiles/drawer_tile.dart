import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../state.dart';


class DrawerTile extends ConsumerWidget {
	const DrawerTile(this.section);

	final Section section;

	@override
	Widget build(BuildContext context, WidgetRef ref) {
		return ListTile(
			onTap: () {
				ref.read(homeStateProvider.notifier).state = section;
				Navigator.of(context).pop();
			},
			selected: ref.watch(homeStateProvider) == section,
			title: Text(section.name),
			leading: Icon(section.icon),
		);
	}
}
