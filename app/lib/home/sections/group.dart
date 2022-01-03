import 'package:flutter/material.dart';

import 'section.dart';


class GroupSection extends Section {
	@override
	final String name = "group";
	@override
	final IconData icon = Icons.people;

	const GroupSection();

	@override
	Widget build(BuildContext context) {
		return Center(child: Icon(icon));
	}
}
