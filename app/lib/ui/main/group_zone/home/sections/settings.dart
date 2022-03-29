import 'package:flutter/material.dart';

import 'section.dart';


class SettingsSection extends Section {
	const SettingsSection();

	@override
	String get name => "settings";
	@override
	IconData get icon => Icons.settings;

	@override
	Widget build(BuildContext context, _) {
		return Center(child: Icon(icon));
	}
}
