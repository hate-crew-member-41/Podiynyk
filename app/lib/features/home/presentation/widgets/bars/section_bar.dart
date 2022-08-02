import 'package:flutter/material.dart';

import '../../state.dart';
import 'counted_icon.dart';


// think: open the drawer on a tap
class SectionBar extends StatelessWidget implements PreferredSizeWidget {
	const SectionBar({
		required this.section,
		this.count,
		this.bottom
	});

	final Section section;
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
					Text(section.name),
					CountedIcon(icon: section.icon, count: count)
				]
			),
			bottom: bottom
		);
	}
}
