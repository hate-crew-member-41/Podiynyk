import 'package:flutter/material.dart';

import '../../domain/entities/event.dart';
import 'entity_tile.dart';


class EventTile extends StatelessWidget {
	const EventTile(this.event);

	final Event event;

	@override
	Widget build(BuildContext context) {
		return EntityTile(
			title: event.name,
			subtitle: event.subject?.name,
			trailing: event.date.shortRepr,
			pageBuilder: (context) => EventPage(event)
		);
	}
}


// think: define EntityPage
class EventPage extends StatelessWidget {
	const EventPage(this.event);

	final Event event;

	@override
	Widget build(BuildContext context) {
		return Scaffold(body: Center(child: ListView(
			shrinkWrap: true,
			// do: take the values from the theme
			children: [
				const SizedBox(height: 56),
				Text(event.name),
				if (event.subject != null) Text(event.subject!.name),
				Text(event.date.repr),
				if (event.note != null) ...[
					const SizedBox(height: 56),
					Text(event.note!)
				],
				const SizedBox(height: 56)
			]
		)));
	}
}
