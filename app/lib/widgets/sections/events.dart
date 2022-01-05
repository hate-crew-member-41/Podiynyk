import 'package:flutter/material.dart';

import 'agenda.dart' show NewEventPage;
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

	@override
	void addAction(BuildContext context) {
		Navigator.of(context).push(MaterialPageRoute(
			builder: (context) => NewEventPage.noSubjectEvent()
		));
	}
}
