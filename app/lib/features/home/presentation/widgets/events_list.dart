import 'package:flutter/material.dart';

import '../../domain/entities/event.dart';
import 'entities_list.dart';


class EventsList extends EntitiesList<Event> {
	const EventsList(super.entities);

	@override
	Widget tile(Event event) => ListTile(
		title: Text(event.name),
		subtitle: event.subject != null ? Text(event.subject!.name) : null,
		trailing: Text(event.date.shortRepr)
	);
}
