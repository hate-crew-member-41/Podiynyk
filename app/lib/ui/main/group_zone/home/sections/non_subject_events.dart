import 'package:flutter/material.dart';

import 'package:podiynyk/storage/cloud.dart';
import 'package:podiynyk/storage/entities/date.dart';
import 'package:podiynyk/storage/entities/event.dart';
import 'package:podiynyk/storage/entities/student.dart' show Role;

import 'section.dart';
import 'agenda.dart';
import 'new_entity_pages/event.dart';


class NonSubjectEventsSectionData extends CloudEntitiesSectionData<Event> {
	@override
	Future<List<Event>> get entities => Cloud.nonSubjectEvents;

	@override
	Future<Iterable<Event>> get counted => currentEntities.then((events) =>
		events.where((event) => !event.date.isPast)
	);
}


class NonSubjectEventsSection extends CloudEntitiesSection<NonSubjectEventsSectionData, Event> {
	static const name = "events";
	static const icon = Icons.event_note;

	@override
	String get sectionName => name;
	@override
	IconData get sectionIcon => icon;

	@override
	Widget? get actionButton => Cloud.userRole == Role.ordinary ? null : NewEntityButton(
		pageBuilder: (_) => const NewEventPage.nonSubjectEvent()
	);

	@override
	NonSubjectEventsSectionData get data => NonSubjectEventsSectionData();

	@override
	List<Widget> tiles(BuildContext context, List<Event> events) => [
		for (final event in events) EventTile(event),
		if (Cloud.userRole != Role.ordinary) const ListTile()
	];
}
