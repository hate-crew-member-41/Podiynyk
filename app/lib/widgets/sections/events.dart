import 'package:flutter/material.dart';

import 'section.dart';


class EventsSection extends Section {
	@override
	final name = "events";
	@override
	final icon = Icons.event_note;
	@override
	final hasAddAction = true;

	const EventsSection();

	@override
	Widget build(BuildContext context) {
		return Center(child: Icon(icon));
	}
}
