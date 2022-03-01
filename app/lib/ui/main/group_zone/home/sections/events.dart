import 'package:flutter/material.dart';

import 'package:podiynyk/storage/cloud.dart';
import 'package:podiynyk/storage/entities/event.dart';
import 'package:podiynyk/storage/entities/student.dart' show Role;

import 'section.dart';
import 'agenda.dart';
import 'new_entity_pages/event.dart';


class NonSubjectEventsSectionCloudData extends CloudEntitiesSectionData<Event> {
	final events = Cloud.nonSubjectEvents;

	@override
	Future<Iterable<Event>> get counted => events.then((events) =>
		events.where((event) => !event.date.isPast)
	);
}


class NonSubjectEventsSection extends CloudEntitiesSection<NonSubjectEventsSectionCloudData, Event> {
	static const name = "events";
	static const icon = Icons.event_note;

	NonSubjectEventsSection() : super(NonSubjectEventsSectionCloudData());

	@override
	String get sectionName => name;
	@override
	IconData get sectionIcon => icon;
	@override
	Widget? get actionButton => Cloud.role == Role.ordinary ? super.actionButton : NewEntityButton(
		pageBuilder: (_) => const NewEventPage.noSubjectEvent()
	);

	@override
	Future<List<Event>> get entities => data.events;

	@override
	List<Widget> tiles(BuildContext context, List<Event> events) => [
		for (final event in events) EventTile(event),
		const ListTile()
	];
}
