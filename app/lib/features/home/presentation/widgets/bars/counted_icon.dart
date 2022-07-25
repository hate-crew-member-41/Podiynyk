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
				if (count != null) ...[
					Text(count.toString()),
					// do: take from the theme
					const SizedBox(width: 16)
				],
				Icon(icon)
			]
		);
	}
}
