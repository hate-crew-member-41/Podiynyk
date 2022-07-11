import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../domain/entities/event.dart';
import '../../../domain/entities/subject.dart';
import '../../../domain/providers/events.dart';
import '../../../domain/providers/subjects.dart';

import '../../widgets/home_section_bar.dart';
import '../../widgets/section.dart';


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
				ListView(children: _tiles(subjects, events)) :
				Center(child: Icon(icon))
		);
	}

	List<ListTile> _tiles(Iterable<Subject> subjects, Iterable<Event> events) {
		return subjects.map((subject) {
			final nextEvent = events.firstWhereOrNull((event) => event.subject == subject);
			final hasEvents = nextEvent != null;

			return ListTile(
				title: Text(subject.name),
				subtitle: hasEvents ? Text(nextEvent.name) : null,
				trailing: hasEvents ? Text(nextEvent.date.shortRepr) : null
			);
		}).toList();
	}
}
