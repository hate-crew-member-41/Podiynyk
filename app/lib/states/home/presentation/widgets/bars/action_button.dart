import 'package:flutter/material.dart';


// think: remove
class ActionButton extends StatelessWidget {
	const ActionButton({
		required this.icon,
		required this.action
	});

	final IconData icon;
	final void Function() action;

	@override
	Widget build(BuildContext context) {
		// do: explore the parameters
		return IconButton(
			icon: Icon(icon),
			onPressed: action
		);
	}
}
