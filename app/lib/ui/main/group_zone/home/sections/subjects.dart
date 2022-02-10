import 'package:flutter/material.dart';

import 'package:podiynyk/storage/cloud.dart' show Cloud;
import 'package:podiynyk/storage/local.dart';
import 'package:podiynyk/storage/entities/subject.dart';

import 'section.dart';
import 'entity_pages/subject.dart';
import 'new_entity_pages/subject.dart';


class SubjectsSectionCloudData extends CloudEntitiesSectionData<Subject> {
	final subjects = Cloud.subjectsWithEvents;

	@override
	Future<List<Subject>> get counted => subjects;
}


class SubjectsSection extends CloudEntitiesSection<SubjectsSectionCloudData, Subject> {
	static const name = "subjects";
	static const icon = Icons.school;

	SubjectsSection() : super(SubjectsSectionCloudData());

	@override
	String get sectionName => name;
	@override
	IconData get sectionIcon => icon;
	@override
	Widget get actionButton => NewEntityButton(
		pageBuilder: (_) => NewSubjectPage()
	);

	@override
	Future<List<Subject>> get entities => data.subjects;

	@override
	List<Widget> tiles(BuildContext context, List<Subject> subjects) {
		final unfollowed = subjects.where((subject) =>
			Local.entityIsStored(DataBox.unfollowedSubjects, subject)
		).toList();
		subjects.removeWhere((subject) => unfollowed.contains(subject));

		return [
			for (final subject in subjects) tile(context, subject),
			for (final subject in unfollowed) Opacity(opacity: 0.6, child: tile(context, subject)),
			const ListTile()
		];
	}

	Widget tile(BuildContext context, Subject subject) {
		return ListTile(
			title: Text(subject.name),
			subtitle: Text(subject.eventCountRepr),
			trailing: subject.events.isNotEmpty ? Text(subject.events.first.date.dateRepr) : null,
			onTap: () => Navigator.of(context).push(MaterialPageRoute(
				builder: (context) => SubjectPage(subject)
			))
		);
	}
}
