import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:podiynyk/storage/appearance.dart';
import 'package:podiynyk/storage/cloud.dart';
import 'package:podiynyk/storage/identifier.dart';
import 'package:podiynyk/storage/local.dart';
import 'package:podiynyk/storage/entities/date.dart';
import 'package:podiynyk/storage/entities/event.dart';
import 'package:podiynyk/storage/entities/student.dart';
import 'package:podiynyk/storage/entities/subject.dart';

import 'package:podiynyk/ui/widgets/input_field.dart';

import '../providers.dart' show eventsNotifierProvider, subjectInfoNotifierProvider, subjectsNotifierProvider;
import '../new_entity_pages/event.dart';
import '../new_entity_pages/subject_info.dart';
import '../widgets/entity_tile.dart';
import '../widgets/new_entity_button.dart';

import 'entity.dart';
import 'event.dart';
import 'subject_info.dart';


class SubjectPage extends HookConsumerWidget {
	SubjectPage(this.initial) :
		userIsLeader = Local.userRole == Role.leader;

	final Subject initial;
	final bool userIsLeader;

	@override
	Widget build(BuildContext context, WidgetRef ref) {
		final subject = useRef(initial);
		final nameField = useTextEditingController(text: initial.nameRepr);
		final followed = useRef(initial.isFollowed);

		useEffect(() {
			if (!initial.hasDetails) initial.withDetails.then((withDetails) {
				subject.value = withDetails;
				ref.read(subjectInfoNotifierProvider.notifier).update(withDetails.info!);
			});

			Future.delayed(Duration.zero, () => ref.read(subjectInfoNotifierProvider.notifier).init(initial));

			return null;
		}, const []);

		return ScaffoldMessenger(child: Builder(
			builder: (context) => EntityPage(
				children: [
					InputField(
						controller: nameField,
						name: "name",
						style: Appearance.headlineText
					),
					const ListTile(),
					ListTile(
						title: const Text("information"),
						onTap: () => _showInfo(context, subject)
					),
					ListTile(
						title: const Text("events"),
						onTap: () => _showEvents(context, subject.value)
					)
				],
				actions: () => [
					followed.value ?
						EntityActionButton(
							text: "unfollow",
							action: () => followed.value = false
						) :
						EntityActionButton(
							text: "follow",
							action: () => followed.value = true
						),
					if (userIsLeader)
						EntityActionButton(
							text: "delete",
							action: () => _handleDelete(context, ref, subject.value)
						)
				],
				onClose: () => _onClose(ref, subject.value, nameField.text, followed.value)
			),
		));
	}

	void _showInfo(BuildContext context, ObjectRef<Subject> subject) => _showEntitiesPage(
		context,
		(context) => _EntitiesPage(
			tilesBuilder: (ref) {
				final info = ref.watch(subjectInfoNotifierProvider);

				if (info != null) return [
					for (final item in info) EntityTile(
						title: item.nameRepr,
						pageBuilder: () => SubjectInfoPage(item, subject: subject),
					)
				];

				return null;
			},
			newEntityPageBuilder: () => const NewSubjectInfoPage()
		)
	);

	void _showEvents(BuildContext context, Subject subject) => _showEntitiesPage(
		context,
		(context) => _EntitiesPage(
			tilesBuilder: (ref) {
				final events = ref.watch(eventsNotifierProvider)!.where((event) =>
					event.subject?.id == initial.id
				);
				return [
					for (final event in events) EntityTile(
						title: event.nameRepr,
						trailing: event.date.dateRepr,
						pageBuilder: () => EventPage(event)
					)
				];
			},
			newEntityPageBuilder: () => NewEventPage.subjectEvent(subject)
		)
	);

	void _showEntitiesPage(BuildContext context, Widget Function(BuildContext) pageBuilder) {
		Navigator.of(context).push(MaterialPageRoute(builder: pageBuilder));
	}

	void _handleDelete(BuildContext context, WidgetRef ref, Subject subject) {
		final events = ref.read(eventsNotifierProvider)!.where((event) =>
			event.subject?.id == initial.id
		).toList();
		if (events.isEmpty) {
			_delete(context, ref, subject, events);
			return;
		}

		final messenger = ScaffoldMessenger.of(context);
		messenger.showSnackBar(SnackBar(
			padding: EdgeInsets.zero,
			content: Column(
				mainAxisSize: MainAxisSize.min,
				crossAxisAlignment: CrossAxisAlignment.start,
				children: [
					const Text("The events will also be deleted.").withPadding,
					ElevatedButton(
						child: const Text("continue"),
						onPressed: () {
							_delete(context, ref, subject, events);
							messenger.hideCurrentSnackBar();
						}
					).withPadding
				]
			)
		));
	}

	void _delete(BuildContext context, WidgetRef ref, Subject subject, List<Event> events) {
		Cloud.deleteEntity(subject);
		Cloud.deleteEvents(events);
		Navigator.of(context).pop();
		ref.read(subjectsNotifierProvider.notifier).update();
	}

	void _onClose(WidgetRef ref, Subject current, String nameRepr, bool followed) {
		final updated = Subject.modified(
			subject: current,
			nameRepr: nameRepr,
			followed: followed,
			info: ref.read(subjectInfoNotifierProvider)
		);

		bool notifySection = false;

		if (updated.isFollowed != current.isFollowed) {
			if (!updated.isFollowed) {
				Local.storeEntity(Identifier.unfollowedSubjects, updated);
			}
			else {
				Local.deleteEntity(Identifier.unfollowedSubjects, updated);
			}

			notifySection = true;
		}

		if (updated.hasDetails) {
			if (!initial.hasDetails || ref.read(subjectInfoNotifierProvider.notifier).changed) {
				notifySection = true;
			}
		}

		if (notifySection) {
			ref.read(subjectsNotifierProvider.notifier).updateEntity(updated);
		}
	}
}


class _EntitiesPage extends StatelessWidget {
	const _EntitiesPage({
		required this.tilesBuilder,
		required this.newEntityPageBuilder
	});

	final List<Widget>? Function(WidgetRef) tilesBuilder;
	final Widget Function() newEntityPageBuilder;

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			body: Center(child: Consumer(builder: (context, ref, _) {
				final tiles = tilesBuilder(ref);

				if (tiles != null) return ListView(
					shrinkWrap: true,
					children: tiles
				);

				return const Text("awaiting");
			})),
			floatingActionButton: Local.userRole == Role.ordinary ? null : NewEntityButton(
				pageBuilder: newEntityPageBuilder
			)
		);
	}
}
