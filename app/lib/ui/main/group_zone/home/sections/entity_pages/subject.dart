import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:podiynyk/storage/appearance.dart';
import 'package:podiynyk/storage/cloud.dart';
import 'package:podiynyk/storage/entities/date.dart';
import 'package:podiynyk/storage/entities/student.dart';
import 'package:podiynyk/storage/entities/subject.dart';

import 'package:podiynyk/ui/main/widgets/input_field.dart';

import '../providers.dart' show eventsNotifierProvider, subjectInfoProvider, subjectsNotifierProvider;
import '../new_entity_pages/event.dart';
import '../new_entity_pages/subject_info.dart';
import '../widgets/entity_tile.dart';
import '../widgets/new_entity_button.dart';

import 'entity.dart';
import 'event.dart';
import 'subject_info.dart';


class SubjectPage extends HookConsumerWidget {
	const SubjectPage(this.initial);

	final Subject initial;

	@override
	Widget build(BuildContext context, WidgetRef ref) {
		final subject = useRef(initial);
		final nameField = useTextEditingController(text: initial.nameRepr);

		useEffect(() {
			if (!initial.hasDetails) initial.withDetails.then((withDetails) {
				subject.value = withDetails;
				ref.read(subjectInfoProvider.notifier).update(withDetails.info!);
			});

			Future.delayed(Duration.zero, () => ref.read(subjectInfoProvider.notifier).init(initial));

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
						onTap: () => _showInfo(context)
					),
					ListTile(
						title: const Text("events"),
						onTap: () => _showEvents(context, subject.value)
					)
				],
				// actions: [
				// 	subject.isFollowed ? EntityActionButton(
				// 		text: "unfollow",
				// 		action: () => subject.isFollowed = false
				// 	) : EntityActionButton(
				// 		text: "follow",
				// 		action: () => subject.isFollowed = true
				// 	),
				// 	if (Cloud.userRole == Role.leader) EntityActionButton(
				// 		text: "delete",
				// 		action: () => _askDelete(context, ref)
				// 	)
				// ],
				onClose: () {
					final current = Subject.modified(
						subject: subject.value,
						nameRepr: nameField.text,
						info: ref.read(subjectInfoProvider)
					);

					if (current.nameRepr != initial.nameRepr) {
						ref.read(subjectsNotifierProvider.notifier).replace(initial, current, preserveState: false);
					}
					else if (current.hasDetails && (
						!initial.hasDetails || ref.read(subjectInfoProvider.notifier).changed
					)) {
						ref.read(subjectsNotifierProvider.notifier).replace(initial, current);
					}
				}
			),
		));
	}

	void _showInfo(BuildContext context) => _showEntitiesPage(
		context,
		(_) => _EntitiesPage(
			tilesBuilder: (ref) {
				final info = ref.watch(subjectInfoProvider);

				if (info != null) return [
					for (final index in Iterable<int>.generate(info.length)) EntityTile(
						title: info[index].nameRepr,
						pageBuilder: () => SubjectInfoPage(ref.read(subjectInfoProvider)![index]),
					)
				];

				return null;
			},
			newEntityPageBuilder: () => const NewSubjectInfoPage()
		)
	);

	void _showEvents(BuildContext context, Subject subject) => _showEntitiesPage(
		context,
		(_) => _EntitiesPage(
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

	// void _askDelete(BuildContext context, WidgetRef ref) {
	// 	if (subject.events!.isEmpty) {
	// 		_delete(context, ref);
	// 		return;
	// 	}

	// 	final messenger = ScaffoldMessenger.of(context);
	// 	messenger.showSnackBar(SnackBar(
	// 		padding: Appearance.padding,
	// 		content: Column(
	// 			mainAxisSize: MainAxisSize.min,
	// 			crossAxisAlignment: CrossAxisAlignment.start,
	// 			children: [
	// 				const Text("The events will also be deleted.").withPadding(horizontal: false),
	// 				ElevatedButton(
	// 					child: const Text("continue"),
	// 					onPressed: () {
	// 						_delete(context, ref);
	// 						messenger.hideCurrentSnackBar();
	// 					}
	// 				)
	// 			]
	// 		)
	// 	));
	// }

	// void _delete(BuildContext context, WidgetRef ref) {
	// 	subject.delete();
	// 	Navigator.of(context).pop();
	// 	(ref.read(sectionProvider) as EntitiesSection).update(ref);
	// }
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
			body: Center(child: Consumer(builder: (_, ref, __) {
				final tiles = tilesBuilder(ref);

				if (tiles != null) return ListView(
					shrinkWrap: true,
					children: tiles
				);

				return const Text("awaiting");
			})),
			floatingActionButton: Cloud.userRole == Role.ordinary ? null : NewEntityButton(
				pageBuilder: newEntityPageBuilder
			)
		);
	}
}
