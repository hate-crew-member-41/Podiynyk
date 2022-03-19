import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:podiynyk/storage/appearance.dart';
import 'package:podiynyk/storage/cloud.dart';
import 'package:podiynyk/storage/entities/student.dart';
import 'package:podiynyk/storage/entities/subject.dart';

import 'package:podiynyk/ui/main/common/fields.dart' show InputField;

import '../agenda.dart' show EventTile;
import '../section.dart' show EntityTile, NewEntityButton;
import '../new_entity_pages/event.dart';
import '../new_entity_pages/subject.dart' show NewSubjectInfoPage;
import 'entity.dart';


class SubjectPage extends HookWidget {
	const SubjectPage(this.subject);

	final Subject subject;

	@override
	Widget build(BuildContext context) {
		final nameField = useTextEditingController(text: subject.nameRepr);

		final hasDetails = useState(subject.hasDetails);

		useEffect(() {
			subject.addDetails().whenComplete(() => hasDetails.value = subject.hasDetails);
			return () => subject.label = nameField.text;
		}, const []);

		return EntityPage(
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
					action: () => _askDelete(context)
				)
			]
		);
	}

	void _showInfo(BuildContext context) => _showEntities(
		context,
		[
			for (final item in subject.info!) EntityTile(
				title: item.nameRepr,
				pageBuilder: () => SubjectInfoPage(item),
			)
		],
		(_) => NewSubjectInfoPage(subject: subject)
	);

	void _showEvents(BuildContext context) => _showEntities(
		context,
		[
			for (final event in subject.events!) EventTile(event, showSubject: false)
		],
		(_) => NewEventPage.subjectEvent(subject)
	);

	void _showEntities(
		BuildContext context,
		List<Widget> entities,
		Widget Function(BuildContext) newEntityPageBuilder
	) {
		Navigator.of(context).push(MaterialPageRoute(
			builder: (context) => Scaffold(
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

	void _askDelete(BuildContext context) {
		if (subject.events!.isEmpty) {
			_delete(context);
			return;
		}

		showDialog(
			context: context,
			builder: (_) => AlertDialog(
				title: const Text("Sure?"),
				content: const Text("The subject's events will also be deleted."),
				actions: [
					TextButton(
						child: const Text("no"),
						onPressed: () => Navigator.of(context).pop()
					),
					TextButton(
						child: const Text("yes"),
						onPressed: () {
							Navigator.of(context).pop();
							_delete(context);
						}
					)
				]
			)
		);
	}

	void _delete(BuildContext context) {
		Cloud.deleteSubject(subject);
		Navigator.of(context).pop();
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
			info.label = nameField.text;
			if (contentField.text.isNotEmpty) info.content = contentField.text;
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
