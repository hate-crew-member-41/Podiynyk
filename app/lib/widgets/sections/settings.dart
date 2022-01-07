import 'package:flutter/material.dart';

import 'section.dart' show Section;


class SettingsSection extends Section {
	@override
	final name = "settings";
	@override
	final icon = Icons.settings;

	const SettingsSection();

	@override
	Widget build(BuildContext context) {
		return Center(child: Icon(icon));
	}
}
