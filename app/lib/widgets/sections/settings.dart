import 'package:flutter/material.dart';

import 'section.dart';


class SettingsSection extends Section {
	@override
	final name = "settings";
	@override
	final icon = Icons.settings;
	@override
	final hasAddAction = false;

	const SettingsSection();

	@override
	Widget build(BuildContext context) {
		return Center(child: Icon(icon));
	}
}
