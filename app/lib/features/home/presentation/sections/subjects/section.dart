import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../domain/entities/subject.dart';
import '../../../domain/providers/events.dart';
import '../../../domain/providers/subjects.dart';

import '../../widgets/entity_list.dart';
import '../../widgets/entity_tile.dart';
import '../../widgets/home_section_bar.dart';

import '../section.dart';
import 'form.dart';
import 'page.dart';


class SubjectsSection extends HomeSection {
	const SubjectsSection();

	@override
	final String name = "subjects";
	@override
	final IconData icon = Icons.school;

	@override
	Widget build(BuildContext context, WidgetRef ref) {
		var subjects = ref.watch(subjectsProvider);
		subjects = subjects?.where((s) => s.isStudied)
			.followedBy(subjects.where((s) => !s.isStudied));

		final events = ref.watch(eventsProvider);

		return Scaffold(
			appBar: HomeSectionBar(
				name: name,
				icon: icon,
				// do: change
				count: subjects?.length
			),
			body: EntityList<Subject>(
				subjects != null && events != null ? subjects : null,
				tile: (subject) {
					final nextEvent = events!.firstWhereOrNull((e) => e.subject == subject);
					return Opacity(
						opacity: subject.isStudied ? 1 : .5,
						child: EntityTile(
							title: subject.name,
							subtitle: nextEvent?.name,
							trailing: nextEvent?.date.shortRepr,
							pageBuilder: (context) => SubjectPage(subject)
						)
					);
				},
				formBuilder: (context) => const SubjectForm()
			)
		);
	}
}
