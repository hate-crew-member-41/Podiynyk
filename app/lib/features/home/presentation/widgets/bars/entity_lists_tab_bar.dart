import 'package:flutter/material.dart';


// think: this makes no sense
class EntityListsTabBar extends StatelessWidget implements PreferredSizeWidget {
	const EntityListsTabBar({required this.tabIcons});

	final List<Widget> tabIcons;

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
