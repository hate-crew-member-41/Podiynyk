import 'package:flutter/material.dart';

import 'package:podiynyk/storage/cloud.dart' show Cloud;
import 'package:podiynyk/storage/entities/event.dart';

import 'section.dart';
import 'entity_pages/event.dart';


class EventsSection extends StatelessWidget {
	static const name = "events";
	static const icon = Icons.event_note;

	const EventsSection();

	@override
	Widget build(BuildContext context) {
		return FutureBuilder<List<Event>>(
			future: events,
			builder: (context, snapshot) {
				// todo: what is shown while awaiting
				if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: Icon(icon));
				// if (snapshot.hasError) print(snapshot.error);  // todo: consider handling

				return ListView(
					children: [
						for (final event in snapshot.data!) ListTile(
							title: Text(event.name),
							trailing: Text(event.date.dateRepr),
							onTap: () => Navigator.of(context).push(MaterialPageRoute(
								builder: (context) => EventPage(event)
							))
						),
						const ListTile()
					]
				);
			}
		);
	}

	Future<List<Event>> get events async {
		final events = await Cloud.events;
		return events.where((event) => event.subject == null).toList();
	}

	// Widget addEntityButton(BuildContext context) => NewEntityButton(
	// 	pageBuilder: (_) => const NewEventPage.noSubjectEvent()
	// );
}
