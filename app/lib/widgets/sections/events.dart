import 'package:flutter/material.dart';

import 'package:podiynyk/storage/cloud.dart' show Cloud;
import 'package:podiynyk/storage/entities.dart' show Event;

import 'agenda.dart' show NewEventPage;
import 'section.dart';


class EventsSection extends CloudListSection<Event> {
	@override
	final name = "events";
	@override
	final icon = Icons.event_note;
	@override
	final hasAddAction = true;

	const EventsSection();

	@override
	Future<List<Event>> get future => Cloud.events().then(
		(events) => List<Event>.from(events.where((event) => event.subject == null))
	);

	@override
	ListTile tile(Event event) => ListTile(
		title: Text(event.name),
		trailing: Text(event.date.dateRepr)
	);

	@override
	addAction(context) {
		Navigator.of(context).push(MaterialPageRoute(
			builder: (context) => NewEventPage.noSubjectEvent()
		));
	}
}
