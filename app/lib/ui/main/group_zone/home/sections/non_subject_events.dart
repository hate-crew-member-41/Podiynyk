import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:podiynyk/storage/cloud.dart';
import 'package:podiynyk/storage/entities/date.dart';
import 'package:podiynyk/storage/entities/event.dart';
import 'package:podiynyk/storage/entities/student.dart' show Role;

import 'section.dart';
import 'agenda.dart';
import 'new_entity_pages/event.dart';


class NonSubjectEventsNotifier extends EntitiesNotifier<Event> {
	@override
	Future<Iterable<Event>> get entities => Cloud.nonSubjectEvents;

	@override
	Iterable<Event>? get counted => state?.where((event) => !event.date.isPast);
}

final nonSubjectEventsNotifierProvider = StateNotifierProvider<NonSubjectEventsNotifier, Iterable<Event>?>((ref) {
	return NonSubjectEventsNotifier();
});


class NonSubjectEventsSection extends EntitiesSection<Event> {
	static const name = "events";
	static const icon = Icons.event_note;

	@override
	String get sectionName => name;
	@override
	IconData get sectionIcon => icon;

	@override
	StateNotifierProvider<NonSubjectEventsNotifier, Iterable<Event>?> get provider => nonSubjectEventsNotifierProvider;

	@override
	List<Widget> tiles(BuildContext context, Iterable<Event> events) => [
		for (final event in events) EventTile(event),
		if (Cloud.userRole != Role.ordinary) const ListTile()
	];

	@override
	Widget? get actionButton => Cloud.userRole == Role.ordinary ? null : NewEntityButton(
		pageBuilder: () => const NewEventPage.nonSubjectEvent()
	);
}
