import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:podiynyk/storage/cloud.dart';
import 'package:podiynyk/storage/entities/date.dart';
import 'package:podiynyk/storage/entities/event.dart';
import 'package:podiynyk/storage/entities/student.dart';

import 'providers.dart' show EntitiesNotifierProvider, eventsNotifierProvider;
import 'section.dart';

import 'entity_pages/event.dart';
import 'new_entity_pages/event.dart';
import 'widgets/entity_tile.dart';
import 'widgets/new_entity_button.dart';


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
		final events = shownEntities(ref.watch(eventsNotifierProvider))?.toList();

		if (events == null) return Center(child: Icon(icon));
		// if (snapshot.hasError) print(snapshot.error);  // todo: consider handling

		return ListView(children: [
			for (final index in Iterable<int>.generate(events.length)) EntityTile(
				title: events[index].nameRepr,
				subtitle: events[index].subject?.nameRepr,
				trailing: events[index].date.dateRepr,
				pageBuilder: () => EventPage(ref.read(eventsNotifierProvider)![index])
			),
			if (Cloud.userRole != Role.ordinary) const ListTile()
		]);
	}

	@override
	Widget? get actionButton => Cloud.userRole == Role.ordinary ? null : NewEntityButton(
		pageBuilder: () => const NewEventPage()
	);
}
