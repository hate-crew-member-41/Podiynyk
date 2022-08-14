import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:podiinyk/core/domain/user/state.dart';

import '../../../domain/entities/event.dart';

import '../../widgets/entity_list.dart';
import '../../widgets/tiles/entity_tile.dart';

import 'form.dart';
import 'page.dart';


class EventList extends ConsumerWidget {
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
	Widget build(BuildContext context, WidgetRef ref) {
		final user = ref.watch(userProvider);

		final split = events?.where(user.eventIsRelevant).followedBy(
			events!.where((e) => !user.eventIsRelevant(e))
		);

		return EntityList<Event>(
			split,
			tile: (event) => Opacity(
				opacity: user.eventIsRelevant(event) ? 1 : .5,
				child: EntityTile(
					title: event.name,
					subtitle: showSubjects ? event.subject?.name : null,
					trailing: event.date.shortRepr,
					pageBuilder: (context) => EventPage(event)
				)
			),
			formBuilder: isExtendable ? (context) => const EventForm() : null
		);
	}
}
