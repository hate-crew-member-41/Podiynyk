import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:podiinyk/core/domain/user/state.dart';

import '../../../domain/entities/subject.dart';
import '../../../domain/providers/events.dart';
import '../../../domain/providers/subjects.dart';

import '../../widgets/entity_list.dart';
import '../../widgets/bars/section_bar.dart';
import '../../widgets/tiles/entity_tile.dart';

import '../../state.dart';
import 'form.dart';
import 'page.dart';


class SubjectsSection extends ConsumerWidget {
	const SubjectsSection();

	@override
	Widget build(BuildContext context, WidgetRef ref) {
		final user = ref.watch(userProvider);
		Iterable<Subject>? subjects = ref.watch(subjectsProvider);
		subjects = subjects?.where((s) => user.studies(s))
			.followedBy(subjects.where((s) => !user.studies(s)));

		final events = ref.watch(eventsProvider);

		return Scaffold(
			appBar: SectionBar(
				section: Section.subjects,
				// do: change
				count: subjects?.length
			),
			body: EntityList<Subject>(
				subjects != null && events != null ? subjects : null,
				tile: (subject) {
					final nextEvent = events!.firstWhereOrNull((e) => e.subject == subject);
					return Opacity(
						opacity: user.studies(subject) ? 1 : .5,
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
