import 'package:flutter/material.dart';


// think: open the drawer on a tap
class HomeSectionBar extends StatelessWidget implements PreferredSizeWidget {
	const HomeSectionBar({
		required this.name,
		required this.icon,
		this.count,
	});

	final String name;
	final IconData icon;
	final int? count;

	// do: take from the theme
	@override
	Size get preferredSize => const Size.fromHeight(56);

	@override
	Widget build(BuildContext context) {
		return AppBar(
			title: Text(name),
			// do: take the paddings from the theme
			actions: [
				if (count != null) Padding(
					padding: const EdgeInsets.only(right: 16),
					child: Center(child: Text(count.toString()))
				),
				Padding(
					padding: const EdgeInsets.only(right: 16),
					child: Icon(icon)
				)
			]
		);
	}
}
