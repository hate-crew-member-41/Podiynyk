import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:podiinyk/core/domain/user/state.dart';

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
		final subjects = ref.watch(subjectsProvider);
		final events = ref.watch(eventsProvider);

		return Scaffold(
			appBar: SectionBar(
				section: Section.subjects,
				// think: also display the number of unstudied subjects
				count: subjects?.where(user.studies).length
			),
			body: SubjectList(subjects, events: events)
		);
	}
}
