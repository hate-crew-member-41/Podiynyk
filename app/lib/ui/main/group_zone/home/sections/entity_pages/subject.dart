import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:podiynyk/storage/appearance.dart';
import 'package:podiynyk/storage/cloud.dart';
import 'package:podiynyk/storage/entities/student.dart';
import 'package:podiynyk/storage/entities/subject.dart';

import 'package:podiynyk/ui/main/common/fields.dart' show InputField;

import '../agenda.dart';
import '../section.dart';
import '../new_entity_pages/event.dart';
import '../new_entity_pages/subject_info.dart';

import 'subject_info.dart';
import 'entity.dart';


final subjectProvider = StateProvider<Subject?>((ref) {
	return null;
});


class SubjectPage extends HookConsumerWidget {
	const SubjectPage(this.subject);

	final Subject subject;

	@override
	Widget build(BuildContext context, WidgetRef ref) {
		final nameField = useTextEditingController(text: subject.nameRepr);

		// final hasDetails = useState(subject.hasDetails);

		// useEffect(() {
		// 	subject.addDetails().whenComplete(() => hasDetails.value = subject.hasDetails);

		// 	return () {
		// 		if (nameField.text != subject.nameRepr) subject.nameRepr = nameField.text;
		// 	};
		// }, const []);

		return ScaffoldMessenger(child: Builder(
			builder: (context) => EntityPage(
				children: [
					InputField(
						controller: nameField,
						name: "name",
						style: Appearance.headlineText
					),
					const ListTile(),
					if (subject.info != null) ListTile(
						title: const Text("information"),
						onTap: () => _showInfo(context)
					),
					ListTile(
						title: const Text("events"),
						onTap: () => _showEvents(context)
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
				// sectionShouldRebuild: () {
				// 	if (nameField.text != subject.nameRepr) {
				// 		subject.nameRepr = nameField.text;
				// 		return true;
				// 	}

				// 	return false;
				// }
			),
		));
	}

	void _showInfo(BuildContext context) => _showEntitiesPage(
		context,
		(_) => _EntitiesPage(
			tiles: (ref) => [
				for (final item in ref.watch(subjectProvider)!.info!) EntityTile(
					title: item.nameRepr,
					pageBuilder: () => SubjectInfoPage(item),
				)
			],
			newEntityPageBuilder: () => const NewSubjectInfoPage()
		)
	);

	void _showEvents(BuildContext context) => _showEntitiesPage(
		context,
		(_) => _EntitiesPage(
			tiles: (ref) {
				final events = ref.watch(eventsNotifierProvider)!.where((event) => event.subject == subject);
				return [
					for (final event in events) EventTile(event, showSubject: false)
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


class _EntitiesPage extends ConsumerWidget {
	const _EntitiesPage({
		required this.tiles,
		required this.newEntityPageBuilder
	});

	final List<Widget> Function(WidgetRef) tiles;
	final Widget Function() newEntityPageBuilder;

	@override
	Widget build(BuildContext context, WidgetRef ref) {
		return Scaffold(
			body: Center(
				child: ListView(
					shrinkWrap: true,
					children: tiles(ref)
				)
			),
			floatingActionButton: Cloud.userRole == Role.ordinary ? null : NewEntityButton(
				pageBuilder: newEntityPageBuilder
			)
		);
	}
}
