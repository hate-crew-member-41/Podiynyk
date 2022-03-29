import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:podiynyk/storage/cloud.dart';
import 'package:podiynyk/storage/entities/date.dart';
import 'package:podiynyk/storage/entities/event.dart';
import 'package:podiynyk/storage/entities/student.dart';

import 'section.dart';
import 'entity_pages/event.dart';
import 'new_entity_pages/event.dart';


final eventsNotifierProvider = EntitiesNotifierProvider((ref) {
	return EntitiesNotifier(() => Cloud.events);
});


class AgendaSection extends EntitiesSection<Event> {
	const AgendaSection();

	@override
	String get name => "agenda";
	@override
	IconData get icon => Icons.import_contacts;

	@override
	EntitiesNotifierProvider<Event> get provider => eventsNotifierProvider;

	@override
	Iterable<Event>? shownEntities(Iterable<Event>? entities) => entities?.where((event) {
		if (event.isHidden) return false;
		if (event.subject == null) return true;
		return event.subject!.isFollowed;
	});

	@override
	Iterable<Event>? countedEntities(WidgetRef ref) {
		final shown = shownEntities(ref.watch(eventsNotifierProvider));
		return shown?.where((event) => !event.date.isPast);
	}

	@override
	Widget build(BuildContext context, WidgetRef ref) {
		final events = shownEntities(ref.watch(eventsNotifierProvider));

		if (events == null) return Center(child: Icon(icon));
		// if (snapshot.hasError) print(snapshot.error);  // todo: consider handling

		return ListView(children: [
			for (final entity in events) EventTile(entity),
			if (Cloud.userRole != Role.ordinary) const ListTile()
		]);
	}

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
