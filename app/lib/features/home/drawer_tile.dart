import 'package:flutter/material.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:podiinyk/features/home/state.dart';

import 'section.dart';


class DrawerTile extends ConsumerWidget {
	const DrawerTile(this.section);

	final HomeSection section;

	@override
	Widget build(BuildContext context, WidgetRef ref) {
		return ListTile(
			onTap: () => _onTap(context, ref),
			title: Text(section.name),
			leading: Consumer(
				builder: (context, ref, _) {
					final isActive = ref.watch(homeStateProvider) == section;
					final icon = isActive ? section.icon : section.inactiveIcon;
					return Icon(icon);
				}
			)
		);
	}

	void _onTap(BuildContext context, WidgetRef ref) {
		ref.read(homeStateProvider.notifier).state = section;
		Navigator.of(context).pop();
	}
}
