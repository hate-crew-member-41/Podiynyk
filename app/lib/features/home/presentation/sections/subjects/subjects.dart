import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../domain/providers/events.dart';
import '../../../domain/providers/subjects.dart';
import '../../section.dart';


class SubjectsSection extends HomeSection {
	const SubjectsSection();

	@override
	final String name = "subjects";
	@override
	final IconData icon = Icons.school;

	@override
	int? count(WidgetRef ref) => ref.watch(subjectsProvider)?.length;

	@override
	Widget build(BuildContext context, WidgetRef ref) {
		final subjects = ref.watch(subjectsProvider);
		final events = ref.watch(eventsProvider);

		if (subjects == null || events == null) return Center(child: Icon(icon));

		final tiles = <ListTile>[];
		for (final subject in subjects) {
			final nextEvent = events.firstWhereOrNull((event) => event.subject == subject);
			final hasEvents = nextEvent != null;

			tiles.add(ListTile(
				title: Text(subject.name),
				subtitle: hasEvents ? Text(nextEvent.name) : null,
				trailing: hasEvents ? Text(nextEvent.date.shortRepr) : null
			));
		}

		return ListView(children: tiles);
	}
}
