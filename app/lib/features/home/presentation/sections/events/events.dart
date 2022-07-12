import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../domain/entities/event.dart';
import '../../../domain/providers/events.dart';

import '../../widgets/event_tile.dart';
import '../../widgets/entities_list.dart';
import '../../widgets/home_section_bar.dart';

import '../section.dart';


class EventsSection extends HomeSection {
	const EventsSection();

	@override
	final String name = "events";
	@override
	final IconData icon = Icons.event;

	@override
	Widget build(BuildContext context, WidgetRef ref) {
		final events = ref.watch(eventsProvider);

		return Scaffold(
			appBar: HomeSectionBar(
				name: name,
				icon: icon,
				count: events?.length
			),
			body: EntitiesList<Event>(
				events,
				tile: (event) => EventTile(event)
			)
		);
	}
}
