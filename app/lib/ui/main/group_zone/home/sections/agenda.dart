import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:podiynyk/storage/cloud.dart';
import 'package:podiynyk/storage/entities/subject.dart';
import 'package:podiynyk/storage/entities/event.dart';

import 'section.dart';
import 'entity_pages/event.dart';
import 'new_entity_pages/event.dart';


class AgendaSectionCloudData extends CloudEntitiesSectionData<Event> {
	final _eventsAndSubjects = Cloud.eventsAndSubjects;
	late final Future<List<Event>> events;
	late final Future<List<Subject>> subjects;

	AgendaSectionCloudData() {
		events = _eventsAndSubjects.then((eventsAndSubjects) =>
			eventsAndSubjects.item1.where((event) => event.subject?.isFollowed != false).toList()
		);
		subjects = _eventsAndSubjects.then((eventsAndSubjects) => eventsAndSubjects.item2);
	}

	@override
	Future<List<Event>> get counted => events;
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
	Widget get actionButton => const NewSubjectEventButton();

	@override
	Future<List<Event>> get entities => data.events;

	@override
	List<Widget> tiles(BuildContext context, List<Event> events) => [
		for (final entity in events) EventTile(
			entity,
			showSubject: true
		),
		const ListTile()
	];
}


class EventTile extends StatelessWidget {
	final Event event;
	final bool showSubject;

	const EventTile(this.event, {required this.showSubject});

	@override
	Widget build(BuildContext context) {
		return !event.date.isPast ? _builder(context) : Opacity(
			opacity: 0.5,
			child: _builder(context)
		);
	}

	Widget _builder(BuildContext context) => ListTile(
		title: Text(event.name),
		subtitle: showSubject && event.subject != null ? Text(event.subject!.name) : null,
		trailing: Text(event.date.dateRepr),
		onTap: () => Navigator.of(context).push(MaterialPageRoute(
			builder: (context) => EventPage(event)
		))
	);
}


class NewSubjectEventButton extends StatelessWidget {
	const NewSubjectEventButton();

	@override
	Widget build(BuildContext context) {
		return FutureBuilder<List<Subject>>(
			future: (context.read<CloudEntitiesSectionData>() as AgendaSectionCloudData).subjects,
			builder: (context, snapshot) {
				if (snapshot.connectionState == ConnectionState.waiting) return Container();
				// todo: consider handling
				return NewEntityButton(
					pageBuilder: (_) => NewEventPage(subjects: snapshot.data!)
				);
			}
		);
	}
}
