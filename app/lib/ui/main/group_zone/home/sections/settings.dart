import 'package:flutter/material.dart';


class SettingsSection extends StatelessWidget {
	static const name = "settings";
	static const icon = Icons.settings;

	const SettingsSection();

	// todo: define
	@override
	Widget build(BuildContext context) {
		return const Center(child: Icon(icon));
	}
}
