import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:podiynyk/storage/appearance.dart';
import 'package:podiynyk/storage/cloud.dart';
import 'package:podiynyk/storage/entities/student.dart';
import 'package:podiynyk/storage/entities/subject.dart';

import 'package:podiynyk/ui/main/common/fields.dart' show InputField;

import '../../home.dart' show sectionProvider;
import '../agenda.dart' show EventTile;
import '../section.dart';
import '../new_entity_pages/event.dart';
import '../new_entity_pages/subject.dart' show NewSubjectInfoPage;
import 'entity.dart';


class SubjectPage extends HookConsumerWidget {
	const SubjectPage(this.subject);

	final Subject subject;

	@override
	Widget build(BuildContext context, WidgetRef ref) {
		final nameField = useTextEditingController(text: subject.nameRepr);

		final hasDetails = useState(subject.hasDetails);

		useEffect(() {
			subject.addDetails().whenComplete(() => hasDetails.value = subject.hasDetails);

			return () {
				if (nameField.text != subject.nameRepr) subject.nameRepr = nameField.text;
			};
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
					if (subject.info != null) ListTile(
						title: const Text("information"),
						onTap: () => _showInfo(context)
					),
					ListTile(
						title: const Text("events"),
						onTap: () => _showEvents(context)
					)
				],
				actions: [
					subject.isFollowed ? EntityActionButton(
						text: "unfollow",
						action: () => subject.isFollowed = false
					) : EntityActionButton(
						text: "follow",
						action: () => subject.isFollowed = true
					),
					if (Cloud.userRole == Role.leader) EntityActionButton(
						text: "delete",
						action: () => _askDelete(context, ref)
					)
				],
				sectionShouldRebuild: () {
					if (nameField.text != subject.nameRepr) {
						subject.nameRepr = nameField.text;
						return true;
					}

					return false;
				}
			),
		));
	}

	void _showInfo(BuildContext context) => _showEntities(
		context,
		[
			for (final item in subject.info!) EntityTile(
				title: item.nameRepr,
				pageBuilder: () => SubjectInfoPage(item),
			)
		],
		() => NewSubjectInfoPage(subject: subject)
	);

	void _showEvents(BuildContext context) => _showEntities(
		context,
		[
			for (final event in subject.events!) EventTile(event, showSubject: false)
		],
		() => NewEventPage.subjectEvent(subject)
	);

	void _showEntities(
		BuildContext context,
		List<Widget> entities,
		Widget Function() newEntityPageBuilder
	) {
		Navigator.of(context).push(MaterialPageRoute(
			builder: (_) => Scaffold(
				body: Center(
					child: ListView(
						shrinkWrap: true,
						children: entities
					)
				),
				floatingActionButton: Cloud.userRole == Role.ordinary ? null : NewEntityButton(
					pageBuilder: newEntityPageBuilder
				)
			)
		));
	}

	void _askDelete(BuildContext context, WidgetRef ref) {
		if (subject.events!.isEmpty) {
			_delete(context, ref);
			return;
		}

		final messenger = ScaffoldMessenger.of(context);
		messenger.showSnackBar(SnackBar(
			padding: Appearance.padding,
			content: Column(
				mainAxisSize: MainAxisSize.min,
				crossAxisAlignment: CrossAxisAlignment.start,
				children: [
					const Text("The events will also be deleted.").withPadding(horizontal: false),
					ElevatedButton(
						child: const Text("continue"),
						onPressed: () {
							_delete(context, ref);
							messenger.hideCurrentSnackBar();
						}
					)
				]
			)
		));
	}

	void _delete(BuildContext context, WidgetRef ref) {
		subject.delete();
		Navigator.of(context).pop();
		(ref.read(sectionProvider) as EntitiesSection).update(ref);
	}
}


class SubjectInfoPage extends HookWidget {
	final SubjectInfo info;

	const SubjectInfoPage(this.info);

	@override
	Widget build(BuildContext context) {
		final nameField = useTextEditingController(text: info.nameRepr);
		final contentField = useTextEditingController(text: info.content);

		useEffect(() => () {
			if (nameField.text != info.nameRepr) info.nameRepr = nameField.text;
			if (contentField.text != info.content) info.content = contentField.text;
		}, const []);

		return EntityPage(
			children: [
				InputField(
					controller: nameField,
					name: "topic",
					style: Appearance.headlineText
				),
				InputField(
					controller: contentField,
					name: "content",
					multiline: true,
					style: Appearance.bodyText,
				)
			],
			actions: [
				if (Cloud.userRole != Role.ordinary) EntityActionButton(
					text: "delete",
					action: info.delete
				)
			]
		);
	}
}
