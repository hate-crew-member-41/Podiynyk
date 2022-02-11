import 'package:flutter/material.dart';

import 'package:podiynyk/storage/cloud.dart' show Cloud;
import 'package:podiynyk/storage/entities/event.dart';

import 'section.dart';
import 'entity_pages/event.dart';
import 'new_entity_pages/event.dart';


class NonSubjectEventsSectionCloudData extends CloudEntitiesSectionData<Event> {
	final events = Cloud.nonSubjectEvents;

	@override
	Future<List<Event>> get counted => events;
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
	Widget get actionButton => NewEntityButton(
		pageBuilder: (_) => const NewEventPage.noSubjectEvent()
	);

	@override
	Future<List<Event>> get entities => data.events;

	@override
	List<Widget> tiles(BuildContext context, List<Event> events) => [
		for (final event in events) ListTile(
			title: Text(event.name),
			trailing: Text(event.date.dateRepr),
			onTap: () => Navigator.of(context).push(MaterialPageRoute(
				builder: (context) => EventPage(event)
			))
		),
		const ListTile()
	];
}
