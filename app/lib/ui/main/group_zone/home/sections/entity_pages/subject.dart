import 'package:flutter/material.dart';

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


class SubjectPage extends StatefulWidget {
	final Subject subject;
	
	const SubjectPage(this.subject);

	@override
	State<SubjectPage> createState() => _SubjectPageState();
}

class _SubjectPageState extends State<SubjectPage> {
	late final Subject _subject;
	final _nameField = TextEditingController();

	@override
	void initState() {
		super.initState();
		_subject = widget.subject;
		_nameField.text = _subject.nameRepr;
		_subject.addDetails().whenComplete(() => setState(() {}));
	}

	@override
	Widget build(BuildContext context) {
		return EntityPage(
			children: [
				InputField(
					controller: _nameField,
					name: "name",
					style: Appearance.headlineText
				),
				const ListTile(),
				if (_subject.info != null) ListTile(
					title: const Text("information"),
					onTap: _showInfo
				),
				ListTile(
					title: const Text("events"),
					onTap: _showEvents
				)
			],
			actions: [
				_subject.isFollowed ? EntityActionButton(
					text: "unfollow",
					action: () => _subject.isFollowed = false
				) : EntityActionButton(
					text: "follow",
					action: () => _subject.isFollowed = true
				),
				if (Cloud.role == Role.leader) EntityActionButton(
					text: "delete",
					action: () => _askDelete(context)
				)
			]
		);
	}

	void _showInfo() => _showEntities(
		[
			for (final item in _subject.info!) EntityTile(
				title: item.nameRepr,
				pageBuilder: () => SubjectInfoPage(item),
			)
		],
		newEntityPageBuilder: (_) => NewSubjectInfoPage(subject: _subject)
	);

	void _showEvents() => _showEntities(
		[
			for (final event in _subject.events!) EventTile(event, showSubject: false)
		],
		newEntityPageBuilder: (_) => NewEventPage.subjectEvent(_subject)
	);

	void _showEntities(List<Widget> entities, {required Widget Function(BuildContext) newEntityPageBuilder}) {
		Navigator.of(context).push(MaterialPageRoute(
			builder: (context) => Scaffold(
				body: Center(
					child: ListView(
						shrinkWrap: true,
						children: entities
					)
				),
				floatingActionButton: Cloud.role == Role.ordinary ? null : NewEntityButton(
					pageBuilder: newEntityPageBuilder
				)
			)
		));
	}

	void _askDelete(BuildContext context) {
		if (_subject.events!.isEmpty) {
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
		Cloud.deleteSubject(_subject);
		Navigator.of(context).pop();
	}

	@override
	void dispose() {
		_subject.label = _nameField.text;
		super.dispose();
	}
}


class SubjectInfoPage extends StatefulWidget {
	final SubjectInfo info;

	const SubjectInfoPage(this.info);

  @override
  State<SubjectInfoPage> createState() => _SubjectInfoPageState();
}

class _SubjectInfoPageState extends State<SubjectInfoPage> {
	late final SubjectInfo _info;
	final TextEditingController _nameField = TextEditingController();
	final TextEditingController _contentField = TextEditingController();

	@override
	void initState() {
		super.initState();
		_info = widget.info;
		_nameField.text = _info.nameRepr;
		_contentField.text = _info.content;
	}

	@override
	Widget build(BuildContext context) {
		return EntityPage(
			children: [
				InputField(
					controller: _nameField,
					name: "topic",
					style: Appearance.headlineText
				),
				InputField(
					controller: _contentField,
					name: "content",
					isMultiline: true,
					style: Appearance.bodyText,
				)
			],
			actions: [
				if (Cloud.role != Role.ordinary) EntityActionButton(
					text: "delete",
					action: widget.info.delete
				)
			]
		);
	}

	@override
	void dispose() {
		widget.info.label = _nameField.text;

		final content = _contentField.text;
		if (content.isNotEmpty) widget.info.content = content;

		super.dispose();
	}
}
