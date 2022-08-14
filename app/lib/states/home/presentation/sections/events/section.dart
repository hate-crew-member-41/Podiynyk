import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:podiinyk/core/domain/user/state.dart';

import '../../../domain/providers/events.dart';

import '../../state.dart';
import '../../widgets/bars/section_bar.dart';

import 'list.dart';


class EventsSection extends ConsumerWidget {
	const EventsSection();

	@override
	Widget build(BuildContext context, WidgetRef ref) {
		final user = ref.watch(userProvider);
		final events = ref.watch(eventsProvider)?.where(
			(e) => e.subject == null || user.studies(e.subject!)
		);

		return Scaffold(
			appBar: SectionBar(
				section: Section.events,
				count: events?.where(user.eventIsRelevant).length
			),
			body: EventList(events)
		);
	}
}
