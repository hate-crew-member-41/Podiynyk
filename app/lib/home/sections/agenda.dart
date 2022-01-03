import 'package:flutter/material.dart';

import 'section.dart';


class AgendaSection extends Section {
	@override
	final String name = "agenda";
	@override
	final IconData icon = Icons.remove_red_eye;

	const AgendaSection();

	@override
	Widget build(BuildContext context) {
		return Center(child: Icon(icon));
	}
}
