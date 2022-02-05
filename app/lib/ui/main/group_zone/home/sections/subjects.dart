import 'package:flutter/material.dart';

import 'package:podiynyk/storage/local.dart';
import 'package:podiynyk/storage/cloud.dart' show Cloud;
import 'package:podiynyk/storage/entities/event.dart';
import 'package:podiynyk/storage/entities/subject.dart';

import 'section.dart';
import 'entity_pages/subject.dart';
import 'new_entity_pages/subject.dart';


class SubjectsSection extends ExtendableListSection<Subject> {
	@override
	final name = "subjects";
	@override
	final icon = Icons.school;

	@override
	Future<List<Subject>> get entitiesFuture => Cloud.subjectsWithEvents;

	@override
	Future<int> get entityCount => futureEntities.then(
		(subjects) => subjects.where((subject) => !subjectIsUnfollowed(subject)
	).length);

	@override
	List<Widget> tiles(BuildContext context, List<Subject> subjects) {
		final unfollowed = List<Subject>.from(subjects.where(subjectIsUnfollowed));
		subjects.removeWhere((subject) => unfollowed.contains(subject));

		return [
			for (final subject in subjects) tile(context, subject),
			for (final subject in unfollowed) Opacity(opacity: 0.6, child: tile(context, subject)),
		];
	}

	bool subjectIsUnfollowed(Subject subject) => Local.entityIsStored(DataBox.unfollowedSubjects, subject);

	@override
	Widget tile(BuildContext context, Subject subject) {
		final nextEvent = _nextEvent(subject);

		return ListTile(
			title: Text(subject.name),
			subtitle: Text(subject.eventCountRepr),
			trailing: nextEvent != null ? Text(nextEvent.date.dateRepr) : null,
			onTap: () => Navigator.of(context).push(MaterialPageRoute(
				builder: (context) => SubjectPage(subject)
			))
		);
	}

	Event? _nextEvent(Subject subject) {
		if (subject.events!.isEmpty) return null;
		return subject.events!.reduce((nextEvent, event) =>  event.isBefore(nextEvent) ? event : nextEvent);
	}

	@override
	Widget addEntityButton(BuildContext context) => NewEntityButton(pageBuilder: (_) => NewSubjectPage());
}
