import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:podiinyk/core/domain/user/state.dart';

import '../../../domain/entities/subject.dart';
import '../../../domain/providers/events.dart';
import '../../../domain/providers/subjects.dart';

import '../../widgets/bars/section_bar.dart';
import '../../state.dart';

import 'list.dart';


class SubjectsSection extends ConsumerWidget {
	const SubjectsSection();

	@override
	Widget build(BuildContext context, WidgetRef ref) {
		final user = ref.watch(userProvider);
		Iterable<Subject>? subjects = ref.watch(subjectsProvider);
		// do: move the logic to SubjectList
		subjects = subjects?.where((s) => user.studies(s))
			.followedBy(subjects.where((s) => !user.studies(s)));

		final events = ref.watch(eventsProvider);

		return Scaffold(
			appBar: SectionBar(
				section: Section.subjects,
				// do: change
				count: subjects?.length
			),
			body: SubjectList(subjects, events: events)
		);
	}
}
