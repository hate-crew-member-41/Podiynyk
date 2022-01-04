import 'package:flutter/material.dart';

import 'section.dart';


class AgendaSection extends Section {
	@override
	final name = "agenda";
	@override
	final icon = Icons.remove_red_eye;
	@override
	final hasAddAction = true;

	const AgendaSection();

	@override
	Widget build(BuildContext context) {
		return Center(child: Icon(icon));
	}
}
