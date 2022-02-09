import 'package:flutter/material.dart';

import 'package:podiynyk/storage/local.dart';
import 'package:podiynyk/storage/cloud.dart' show Cloud;
import 'package:podiynyk/storage/entities/event.dart';
import 'package:podiynyk/storage/entities/subject.dart';

import 'section.dart';
import 'entity_pages/subject.dart';


class SubjectsSectionCloudData {
	final subjects = Cloud.subjectsWithEvents;
}


class SubjectsSection extends CloudSection {
	static const name = "subjects";
	static const icon = Icons.school;

	SubjectsSection() : super(SubjectsSectionCloudData());

	@override
	String get sectionName => name;
	@override
	IconData get sectionIcon => icon;

	@override
	Widget build(BuildContext context) {
		return FutureBuilder<List<Subject>>(
			future: cloudData.subjects,
			builder: (context, snapshot) {
				// todo: what is shown while awaiting
				if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: Icon(icon));
				// if (snapshot.hasError) print(snapshot.error);  // todo: consider handling

				return ListView(
					children: tiles(context, snapshot.data!)..add(const ListTile())
				);
			}
		);
	}

	// @override
	// Future<int> get entityCount => entitiesFuture.then(
	// 	(subjects) => subjects.where((subject) => !subjectIsUnfollowed(subject)
	// ).length);

	List<Widget> tiles(BuildContext context, List<Subject> subjects) {
		final unfollowed = subjects.where(subjectIsUnfollowed).toList();
		subjects.removeWhere((subject) => unfollowed.contains(subject));

		return [
			for (final subject in subjects) tile(context, subject),
			for (final subject in unfollowed) Opacity(opacity: 0.6, child: tile(context, subject)),
		];
	}

	bool subjectIsUnfollowed(Subject subject) => Local.entityIsStored(DataBox.unfollowedSubjects, subject);

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

	// Widget addEntityButton(BuildContext context) => NewEntityButton(pageBuilder: (_) => NewSubjectPage());
}
