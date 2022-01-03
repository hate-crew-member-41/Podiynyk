import 'package:flutter/material.dart';

import 'section.dart';


class SettingsSection extends Section {
	@override
	final String name = "settings";
	@override
	final IconData icon = Icons.settings;
	@override
	final bool hasAddAction = false;

	const SettingsSection();

	@override
	Widget build(BuildContext context) {
		return Center(child: Icon(icon));
	}
}
