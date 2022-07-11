import 'package:flutter/material.dart';

import 'counted_icon.dart';


// think: open the drawer on a tap
class HomeSectionBar extends StatelessWidget implements PreferredSizeWidget {
	HomeSectionBar({
		required this.name,
		required this.icon,
		this.count,
		List<Tab>? tabs
	}) :
		tabBar = tabs == null ? null : TabBar(tabs: tabs);

	final String name;
	final IconData icon;
	final int? count;
	final TabBar? tabBar;

	// do: take the values from the theme
	@override
	Size get preferredSize {
		double height = 56;
		if (tabBar != null) height += tabBar!.preferredSize.height;
		return Size.fromHeight(height);
	}

	@override
	Widget build(BuildContext context) {
		return AppBar(
			title: Row(
				mainAxisAlignment: MainAxisAlignment.spaceBetween,
				children: [
					Text(name),
					CountedIcon(icon: icon, count: count)
				]
			),
			bottom: tabBar
		);
	}
}
