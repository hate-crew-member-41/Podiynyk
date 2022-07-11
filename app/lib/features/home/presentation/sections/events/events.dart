import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../domain/providers/events.dart';
import '../../section.dart';


class EventsSection extends HomeSection {
	const EventsSection();

	@override
	final String name = "events";
	@override
	final IconData icon = Icons.event;

	@override
	Widget build(BuildContext context, WidgetRef ref) {
		final events = ref.watch(eventsProvider);
	
		if (events == null) return Center(child: Icon(icon));

		return ListView(children: [
			for (final event in events) ListTile(
				title: Text(event.name),
				subtitle: event.subject != null ? Text(event.subject!.name) : null,
				trailing: Text(event.date.shortRepr)
			)
		]);
	}
}
