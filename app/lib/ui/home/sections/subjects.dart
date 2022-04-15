import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:podiynyk/storage/local.dart';
import 'package:podiynyk/storage/entities/date.dart';
import 'package:podiynyk/storage/entities/event.dart';
import 'package:podiynyk/storage/entities/student.dart' show Role;
import 'package:podiynyk/storage/entities/subject.dart';

import 'providers.dart' show EntitiesNotifierProvider, eventsNotifierProvider, subjectsNotifierProvider;
import 'section.dart';

import 'entity_pages/subject.dart';
import 'new_entity_pages/subject.dart';
import 'widgets/entity_tile.dart';
import 'widgets/new_entity_button.dart';


class SubjectsSection extends EntitiesSection<Subject> {
	const SubjectsSection();

	@override
	String get name => "subjects";
	@override
	IconData get icon => Icons.school;

	@override
	EntitiesNotifierProvider<Subject> get provider => subjectsNotifierProvider;

	@override
	Widget build(BuildContext context, WidgetRef ref) {
		final subjects = ref.watch(subjectsNotifierProvider);
		final events = ref.watch(eventsNotifierProvider);

		if (subjects == null || events == null) return Center(child: Icon(icon));
		// if (snapshot.hasError) print(snapshot.error);  // todo: consider handling

		final followed = subjects.where((subject) => subject.isFollowed);
		final unfollowed = subjects.where((subject) => !subject.isFollowed);

		return ListView(children: [
			for (final subject in followed) _Tile(subject),
			for (final subject in unfollowed) _Tile(subject),
			if (Local.userRole == Role.leader) const ListTile()
		]);
	}

	@override
	Widget? get actionButton => Local.userRole != Role.leader ? null : NewEntityButton(
		pageBuilder: () => NewSubjectPage()
	);
}


class _Tile extends ConsumerWidget {
	const _Tile(this.subject);

	final Subject subject;

	@override
	Widget build(BuildContext context, WidgetRef ref) {
		final events = ref.watch(eventsNotifierProvider)!.where((event) => event.subject?.id == subject.id).toList();
		final hasEvents = events.isNotEmpty;

		return EntityTile(
			title: subject.nameRepr,
			subtitle: hasEvents ? Event.countRepr(events.length) : null,
			trailing: hasEvents ? events.first.date.dateRepr : null,
			opaque: subject.isFollowed,
			pageBuilder: () => SubjectPage(subject)
		);
	}
}
