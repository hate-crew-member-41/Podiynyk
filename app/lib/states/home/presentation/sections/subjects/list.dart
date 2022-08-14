import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:podiinyk/core/domain/user/state.dart';

import '../../../domain/entities/event.dart';
import '../../../domain/entities/subject.dart';

import '../../widgets/entity_list.dart';
import '../../widgets/tiles/entity_tile.dart';

import 'form.dart';
import 'page.dart';


class SubjectList extends ConsumerWidget {
	const SubjectList(
		this.subjects, {
			this.showNextEvent = true,
			this.events
		}
	);

	final Iterable<Subject>? subjects;
	final bool showNextEvent;
	final Iterable<Event>? events;

	@override
	Widget build(BuildContext context, WidgetRef ref) {
		final dataIsPresent = subjects != null && (events != null || showNextEvent == false);

		final user = ref.watch(userProvider);
		final split = subjects?.where(user.studies).followedBy(
			subjects!.where((s) => !user.studies(s))
		);

		return EntityList<Subject>(
			dataIsPresent ? split : null,
			tile: (subject) {
				final nextEvent = events?.firstWhereOrNull((e) => e.subject == subject);
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
		);
	}
}
