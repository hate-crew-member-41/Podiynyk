import 'package:flutter/material.dart';

import 'package:podiynyk/storage/cloud.dart' show Cloud;
import 'package:podiynyk/storage/entities/event.dart';

import 'entity_pages/event.dart';
import 'new_entity_pages/event.dart';
import 'section.dart';


class EventsSection extends ExtendableListSection<Event> {
	@override
	final name = "events";
	@override
	final icon = Icons.calendar_today;

	EventsSection() {
		futureEntities = Cloud.events().then((events) =>
			List<Event>.from(events.where((event) => event.subject == null))
		);
	}

	@override
	Widget tile(BuildContext context, Event event) => ListTile(
		title: Text(event.name),
		trailing: Text(event.date.dateRepr),
		onTap: () => Navigator.of(context).push(MaterialPageRoute(
			builder: (context) => EventPage(event)
		))
	);

	@override
	Widget addEntityButton(BuildContext context) => AddEntityButton(newEntityPage: NewEventPage.noSubjectEvent());
}
