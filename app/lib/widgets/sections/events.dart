import 'package:flutter/material.dart';

import 'package:podiynyk/storage/cloud.dart' show Cloud;
import 'package:podiynyk/storage/entities.dart' show Event;

import 'agenda.dart' show NewEventPage;
import 'section.dart';


class EventsSection extends ExtendableListSection<Event> {
	@override
	final name = "events";
	@override
	final icon = Icons.event_note;

	const EventsSection();

	@override
	Future<List<Event>> get entities => Cloud.events().then(
		(events) => List<Event>.from(events.where((event) => event.subject == null))
	);

	@override
	ListTile tile(Event event) => ListTile(
		title: Text(event.name),
		trailing: Text(event.date.dateRepr)
	);

	@override
	Widget addEntityButton(BuildContext context) => AddEntityButton(newEntityPage: NewEventPage.noSubjectEvent());
}
