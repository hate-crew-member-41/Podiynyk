import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:podiynyk/storage/cloud.dart';
import 'package:podiynyk/storage/entities/date.dart';
import 'package:podiynyk/storage/entities/event.dart';
import 'package:podiynyk/storage/entities/student.dart';

import 'section.dart';
import 'entity_pages/event.dart';
import 'new_entity_pages/event.dart';


class AgendaNotifier extends EntitiesNotifier<Event> {
	@override
	Future<Iterable<Event>> get entities async {
		final events = await Cloud.events;

		return events.where((event) {
			final hasSubject = event.subject != null;
			final subjectIsFollowed = hasSubject && event.subject!.isFollowed;
			return !event.isHidden && (subjectIsFollowed || !hasSubject);
		});
	}
}

final agendaNotifierProvider = StateNotifierProvider<AgendaNotifier, Iterable<Event>?>((ref) {
	return AgendaNotifier();
});


class AgendaSection extends EntitiesSection<Event> {
	static const name = "agenda";
	static const icon = Icons.import_contacts;

	@override
	String get sectionName => name;
	@override
	IconData get sectionIcon => icon;

	@override
	StateNotifierProvider<EntitiesNotifier<Event>, Iterable<Event>?> get provider => agendaNotifierProvider;

	@override
	List<Widget> tiles(BuildContext context, Iterable<Event> events) => [
		for (final entity in events) EventTile(entity),
		if (Cloud.userRole != Role.ordinary) const ListTile()
	];

	@override
	Widget? get actionButton => Cloud.userRole == Role.ordinary ? null : NewEntityButton(
		pageBuilder: () => const NewEventPage()
	);
}


class EventTile extends StatelessWidget {
	final Event event;
	final bool showSubject;

	const EventTile(this.event, {this.showSubject = true});

	@override
	Widget build(BuildContext context) {
		return !event.date.isPast ? _builder(context) : Opacity(
			opacity: 0.5,
			child: _builder(context)
		);
	}

	Widget _builder(BuildContext context) => EntityTile(
		title: event.nameRepr,
		subtitle: showSubject ? event.subject?.nameRepr : null,
		trailing: event.date.dateRepr,
		pageBuilder: () => EventPage(event)
	);
}
