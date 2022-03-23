import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:podiynyk/storage/cloud.dart';
import 'package:podiynyk/storage/entities/date.dart';
import 'package:podiynyk/storage/entities/student.dart' show Role;
import 'package:podiynyk/storage/entities/subject.dart';

import 'section.dart';
import 'entity_pages/subject.dart';
import 'new_entity_pages/subject.dart';


class SubjectsNotifier extends EntitiesNotifier<Subject> {
	@override
	Future<Iterable<Subject>> get entities => Cloud.subjectsWithEvents;
}

final subjectsNotifierProvider = StateNotifierProvider<SubjectsNotifier, Iterable<Subject>?>((ref) {
	return SubjectsNotifier();
});


class SubjectsSection extends EntitiesSection<Subject> {
	static const name = "subjects";
	static const icon = Icons.school;

	@override
	String get sectionName => name;
	@override
	IconData get sectionIcon => icon;

	@override
	StateNotifierProvider<EntitiesNotifier<Subject>, Iterable<Subject>?> get provider => subjectsNotifierProvider;

	@override
	List<Widget> tiles(BuildContext context, Iterable<Subject> subjects) {
		final followed = subjects.where((subject) => subject.isFollowed);
		final unfollowed = subjects.where((subject) => !subject.isFollowed);

		return [
			for (final subject in followed) _tile(context, subject),
			for (final subject in unfollowed) Opacity(
				opacity: 0.5,
				child: _tile(context, subject)
			),
			if (Cloud.userRole == Role.leader) const ListTile()
		];
	}

	Widget _tile(BuildContext context, Subject subject) {
		final hasEvents = subject.events!.isNotEmpty;

		return EntityTile(
			title: subject.nameRepr,
			subtitle: hasEvents ? subject.eventCountRepr : null,
			trailing: hasEvents ? subject.events!.first.date.dateRepr : null,
			pageBuilder: () => SubjectPage(subject)
		);
	}

	@override
	Widget? get actionButton => Cloud.userRole != Role.leader ? null : NewEntityButton(
		pageBuilder: () => NewSubjectPage()
	);
}
