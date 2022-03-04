import 'package:flutter/material.dart';

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
		_nameField.text = _subject.name;
		_subject.addDetails().whenComplete(() => setState(() {}));
	}

	@override
	Widget build(BuildContext context) {
		final info = _subject.info;
		final events = _subject.events;

		return EntityPage(
			children: [
				InputField(
					controller: _nameField,
					name: "name",
				),
				if (info != null) TextButton(
					child: const Text("information"),
					onPressed: () => _showEntities(
						[for (final item in info) EntityTile(
							title: item.name,
							pageBuilder: () => SubjectInfoPage(item),
						)],
						newEntityPageBuilder: (_) => NewSubjectInfoPage(_subject)
					)
				),
				TextButton(
					child: Text(_subject.eventCountRepr),
					onPressed: () => _showEntities(
						[for (final event in events) EventTile(event, showSubject: false)],
						newEntityPageBuilder: (_) => NewEventPage.subjectEvent(_subject.name)
					)
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
				// todo: confirmation
				if (Cloud.role == Role.leader) EntityActionButton(
					text: "delete",
					action: () => Cloud.deleteSubject(_subject)
				)
			]
		);
	}

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
		_nameField.text = _info.name;
		_contentField.text = _info.content;
	}

	@override
	Widget build(BuildContext context) {
		return EntityPage(
			children: [
				InputField(
					controller: _nameField,
					name: "topic",
				),
				InputField(
					controller: _contentField,
					name: "content",
				)
			],
			actions: Cloud.role == Role.ordinary ? null : [EntityActionButton(
				text: "delete",
				action: widget.info.delete
			)]
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
