import 'package:flutter/material.dart';


class CountedIcon extends StatelessWidget {
	const CountedIcon({
		required this.icon,
		this.count
	});

	final IconData icon;
	final int? count;

	@override
	Widget build(BuildContext context) {
		return Row(
			mainAxisAlignment: MainAxisAlignment.center,
			children: [
				if (count != null) Padding(
					// do: take from the theme
					padding: const EdgeInsets.only(right: 16),
					child: Text(count.toString())
				),
				Icon(icon)
			]
		);
	}
}
