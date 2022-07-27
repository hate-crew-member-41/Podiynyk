import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:podiinyk/core/domain/user.dart';

import '../../../domain/providers/events.dart';
import '../../widgets/bars/home_section_bar.dart';
import '../section.dart';
import 'list.dart';


class EventsSection extends HomeSection {
	const EventsSection();

	@override
	final String name = "events";
	@override
	final IconData icon = Icons.event;

	@override
	Widget build(BuildContext context, WidgetRef ref) {
		final events = ref.watch(eventsProvider)?.where(
			(e) => e.subject == null || User.studies(e.subject!)
		);

		return Scaffold(
			appBar: HomeSectionBar(
				name: name,
				icon: icon,
				count: events?.length
			),
			body: EventList(events)
		);
	}
}
