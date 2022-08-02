import 'package:flutter/material.dart';

import '../../../domain/entities/event.dart';

import '../../widgets/entity_list.dart';
import '../../widgets/tiles/entity_tile.dart';

import 'form.dart';
import 'page.dart';


class EventList extends StatelessWidget {
	const EventList(
		this.events, {
			this.isExtendable = true,
			this.showSubjects = true
		}
	);

	final Iterable<Event>? events;
	final bool isExtendable;
	final bool showSubjects;

	@override
	Widget build(BuildContext context) {
		return EntityList<Event>(
			events,
			tile: (event) => EntityTile(
				title: event.name,
				subtitle: showSubjects ? event.subject?.name : null,
				trailing: event.date.shortRepr,
				pageBuilder: (context) => EventPage(event)
			),
			formBuilder: isExtendable ? (context) => const EventForm() : null
		);
	}
}
