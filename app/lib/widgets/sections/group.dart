import 'package:flutter/material.dart';

import 'section.dart';


class GroupSection extends Section {
	@override
	final name = "group";
	@override
	final icon = Icons.people;
	@override
	final hasAddAction = false;

	const GroupSection();

	@override
	Widget build(BuildContext context) {
		return Center(child: Icon(icon));
	}
}
