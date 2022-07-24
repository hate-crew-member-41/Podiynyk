import 'package:flutter/material.dart';

import 'counted_icon.dart';


// think: open the drawer on a tap
class HomeSectionBar extends StatelessWidget implements PreferredSizeWidget {
	const HomeSectionBar({
		required this.name,
		required this.icon,
		this.count,
		this.bottom
	});

	final String name;
	final IconData icon;
	final int? count;
	final PreferredSizeWidget? bottom;

	@override
	Size get preferredSize {
		// do: take from the theme
		double height = 56;
		if (bottom != null) height += bottom!.preferredSize.height;
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
			bottom: bottom
		);
	}
}
