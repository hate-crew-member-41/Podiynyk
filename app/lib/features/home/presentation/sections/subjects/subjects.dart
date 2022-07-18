import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../domain/entities/subject.dart';
import '../../../domain/providers/events.dart';
import '../../../domain/providers/subjects.dart';

import '../../widgets/entities_list.dart';
import '../../widgets/home_section_bar.dart';

import '../section.dart';
import 'subject_form.dart';


class SubjectsSection extends HomeSection {
	const SubjectsSection();

	@override
	final String name = "subjects";
	@override
	final IconData icon = Icons.school;

	@override
	Widget build(BuildContext context, WidgetRef ref) {
		final subjects = ref.watch(subjectsProvider);
		final events = ref.watch(eventsProvider);
		final entitiesArePresent = subjects != null && events != null;

		return Scaffold(
			appBar: HomeSectionBar(
				name: name,
				icon: icon,
				count: subjects?.length
			),
			body: entitiesArePresent ?
				EntitiesList<Subject>(
					subjects,
					tile: (subject) {
						final nextEvent = events.firstWhereOrNull((e) => e.subject == subject);
						final hasEvents = nextEvent != null;

						return ListTile(
							title: Text(subject.name),
							subtitle: hasEvents ? Text(nextEvent.name) : null,
							trailing: hasEvents ? Text(nextEvent.date.shortRepr) : null
						);
					},
					formBuilder: (context) => const SubjectForm()
				) :
				Center(child: Icon(icon))
		);
	}
}
