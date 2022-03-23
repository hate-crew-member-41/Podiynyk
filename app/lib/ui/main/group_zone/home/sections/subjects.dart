import 'package:flutter/material.dart';

import 'package:podiynyk/storage/cloud.dart';
import 'package:podiynyk/storage/entities/date.dart';
import 'package:podiynyk/storage/entities/student.dart' show Role;
import 'package:podiynyk/storage/entities/subject.dart';

import 'section.dart';
import 'entity_pages/subject.dart';
import 'new_entity_pages/subject.dart';


class SubjectsSectionData extends CloudEntitiesSectionData<Subject> {
	@override
	Future<List<Subject>> get entitiesFuture => Cloud.subjectsWithEvents;

	@override
	Iterable<Subject>? get countedEntities => entities?.where((subject) => subject.isFollowed);
}


class SubjectsSection extends CloudEntitiesSection<SubjectsSectionData, Subject> {
	static const name = "subjects";
	static const icon = Icons.school;

	@override
	String get sectionName => name;
	@override
	IconData get sectionIcon => icon;
	@override
	
	Widget? get actionButton => Cloud.userRole != Role.leader ? null : NewEntityButton(
		pageBuilder: () => NewSubjectPage()
	);

	@override
	SubjectsSectionData get data => SubjectsSectionData();

	@override
	List<Widget> tiles(BuildContext context, List<Subject> subjects) {
		final followed = subjects.where((subject) => subject.isFollowed);
		final unfollowed = subjects.where((subject) => !subject.isFollowed);

		return [
			for (final subject in followed) tile(context, subject),
			for (final subject in unfollowed) Opacity(
				opacity: 0.5,
				child: tile(context, subject)
			),
			if (Cloud.userRole == Role.leader) const ListTile()
		];
	}

	Widget tile(BuildContext context, Subject subject) {
		final hasEvents = subject.events!.isNotEmpty;

		return EntityTile(
			title: subject.nameRepr,
			subtitle: hasEvents ? subject.eventCountRepr : null,
			trailing: hasEvents ? subject.events!.first.date.dateRepr : null,
			pageBuilder: () => SubjectPage(subject)
		);
	}
}
