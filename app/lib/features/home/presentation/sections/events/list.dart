import 'package:flutter/material.dart';

import '../../../domain/entities/event.dart';

import '../../widgets/entity_list.dart';
import '../../widgets/entity_tile.dart';

import 'form.dart';
import 'page.dart';


class EventsList extends StatelessWidget {
	const EventsList(this.events);

	final Iterable<Event>? events;

	@override
	Widget build(BuildContext context) {
		return EntityList<Event>(
			events,
			tile: (event) => EntityTile(
				title: event.name,
				subtitle: event.subject?.name,
				trailing: event.date.shortRepr,
				pageBuilder: (context) => EventPage(event)
			),
			formBuilder: (context) => const EventForm()
		);
	}
}
