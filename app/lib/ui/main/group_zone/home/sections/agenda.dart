import 'package:flutter/material.dart';

import 'package:podiynyk/storage/cloud.dart';
import 'package:podiynyk/storage/entities/date.dart';
import 'package:podiynyk/storage/entities/event.dart';
import 'package:podiynyk/storage/entities/student.dart' show Role;

import 'section.dart';
import 'entity_pages/event.dart';
import 'new_entity_pages/event.dart';


class AgendaSectionData extends CloudEntitiesSectionData<Event> {
	@override
	Future<List<Event>> get entitiesFuture => Cloud.events.then((events) =>
		events.where((event) {
			final hasSubject = event.subject != null;
			return !event.isHidden && (
				(hasSubject && event.subject!.isFollowed) ||
				!hasSubject
			);
		}).toList()
	);

	@override
	Iterable<Event>? get countedEntities => entities?.where((event) => !event.date.isPast);
}


class AgendaSection extends CloudEntitiesSection<AgendaSectionData, Event> {
	static const name = "agenda";
	static const icon = Icons.import_contacts;

	@override
	String get sectionName => name;
	@override
	IconData get sectionIcon => icon;

	@override
	Widget? get actionButton => Cloud.userRole == Role.ordinary ? null : NewEntityButton(
		pageBuilder: () => const NewEventPage()
	);

	@override
	AgendaSectionData get data => AgendaSectionData();

	@override
	List<Widget> tiles(BuildContext context, List<Event> events) => [
		for (final entity in events) EventTile(entity),
		if (Cloud.userRole != Role.ordinary) const ListTile()
	];
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
