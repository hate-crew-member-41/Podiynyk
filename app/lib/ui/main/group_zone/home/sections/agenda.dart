import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:podiynyk/storage/cloud.dart' show Cloud, Subjects;
import 'package:podiynyk/storage/entities/subject.dart';
import 'package:podiynyk/storage/local.dart';
import 'package:podiynyk/storage/entities/event.dart';

import 'section.dart';
import 'entity_pages/event.dart';
import 'new_entity_pages/event.dart';


class AgendaSectionCloudData extends CloudSectionData {
	// todo: completely redo storing entities
	final subjects = Cloud.subjectsWithEvents.then((subjects) {
		final unfollowedEssences = Local.storedEntities<SubjectEssence>(DataBox.unfollowedSubjects);
		return subjects.where((subject) =>
			!unfollowedEssences.contains(subject.essence)
		).toList();
	});

	Future<List<Event>> get events => subjects.then((subjects) => subjects.events);

	@override
	Future<List<Event>> get counted => events;
}


class AgendaSection extends CloudSection<AgendaSectionCloudData> {
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
	Widget build(BuildContext context) {
		return FutureBuilder<List<Event>>(
			future: data.events,
			builder: (context, snapshot) {
				// todo: what is shown while awaiting
				if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: Icon(icon));
				// if (snapshot.hasError) print(snapshot.error);  // todo: consider handling

				return ListView(
					children: [
						for (final entity in snapshot.data!) EventTile(
							entity,
							showSubject: true
						),
						const ListTile()
					],
				);
			}
		);
	}
}


class EventTile extends StatelessWidget {
	final Event _event;
	final bool showSubject;

	const EventTile(this._event, {required this.showSubject});

	@override
	Widget build(BuildContext context) {
		return ListTile(
			title: Text(_event.name),
			subtitle: showSubject && _event.subject != null ? Text(_event.subject!.name) : null,
			trailing: Text(_event.date.dateRepr),
			onTap: () => Navigator.of(context).push(MaterialPageRoute(
				builder: (context) => EventPage(_event)
			))
		);
	}
}


class NewSubjectEventButton extends StatelessWidget {
	const NewSubjectEventButton();

	@override
	Widget build(BuildContext context) {
		return FutureBuilder<List<Subject>>(
			future: (context.read<CloudSectionData>() as AgendaSectionCloudData).subjects,
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
