import 'package:flutter/material.dart';


// do: control the gaps
class ActionBar extends StatelessWidget {
	const ActionBar({required this.children});

	final List<Widget> children;

	@override
	Widget build(BuildContext context) {
		return SizedBox(
			// do: take from the theme
			height: 56,
			child: Row(
				mainAxisAlignment: MainAxisAlignment.end,
				children: children
			)
		);
	}
}
