import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:podiynyk/storage/cloud.dart';
import 'package:podiynyk/storage/entities/event.dart';
import 'package:podiynyk/storage/entities/student.dart' show Role;
import 'package:podiynyk/storage/entities/subject.dart';

import 'section.dart';
import 'entity_pages/event.dart';
import 'new_entity_pages/event.dart';


class AgendaSectionCloudData extends CloudEntitiesSectionData<Event> {
	final Future<List<Event>> events = Cloud.events.then((events) =>
		events.where((event) {
			final hasSubject = event.subjectName != null;
			return !event.isHidden && (
				(hasSubject && Subject.withNameIsFollowed(event.subjectName!)) ||
				!hasSubject
			);
		}).toList()
	);

	final Future<List<String>> subjectNames = Cloud.subjectNames;

	@override
	Future<Iterable<Event>> get counted => events.then((events) =>
		events.where((event) => !event.date.isPast)
	);
}


class AgendaSection extends CloudEntitiesSection<AgendaSectionCloudData, Event> {
	static const name = "agenda";
	static const icon = Icons.import_contacts;

	AgendaSection() : super(AgendaSectionCloudData());

	@override
	String get sectionName => name;
	@override
	IconData get sectionIcon => icon;
	@override
	Widget? get actionButton => Cloud.role == Role.ordinary ? super.actionButton : const NewSubjectEventButton();

	@override
	Future<List<Event>> get entities => data.events;

	@override
	List<Widget> tiles(BuildContext context, List<Event> events) => [
		for (final entity in events) EventTile(entity),
		const ListTile()
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
		title: event.name,
		subtitle: showSubject ? event.subjectLabel ?? event.subjectName : null,
		trailing: event.date.dateRepr,
		pageBuilder: () => EventPage(event)
	);
}


// todo: fetch the subjects after the button has been pressed
class NewSubjectEventButton extends StatelessWidget {
	const NewSubjectEventButton();

	@override
	Widget build(BuildContext context) {
		return FutureBuilder<List<String>>(
			future: (context.read<CloudEntitiesSectionData>() as AgendaSectionCloudData).subjectNames,
			builder: (context, snapshot) {
				if (snapshot.connectionState == ConnectionState.waiting) return Container();
				// todo: consider handling
				return NewEntityButton(
					pageBuilder: (_) => NewEventPage(subjectNames: snapshot.data!)
				);
			}
		);
	}
}
