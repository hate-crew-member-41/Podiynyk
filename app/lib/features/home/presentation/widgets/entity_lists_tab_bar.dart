import 'package:flutter/material.dart';

import 'counted_icon.dart';


class EntityListsTabBar extends StatelessWidget implements PreferredSizeWidget {
	const EntityListsTabBar({required this.tabIcons});

	final List<CountedIcon> tabIcons;

	// do: take from the theme
	@override
	Size get preferredSize => const Size.fromHeight(48);

	@override
	Widget build(BuildContext context) {
		return TabBar(tabs: [
			for (final icon in tabIcons) Tab(child: icon),
		]);
	}
}
