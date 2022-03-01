import 'package:flutter/material.dart';

import 'package:podiynyk/storage/cloud.dart';
import 'package:podiynyk/storage/entities/student.dart';
import 'package:podiynyk/storage/entities/subject.dart';

import 'package:podiynyk/ui/main/common/fields.dart' show InputField;

import '../agenda.dart' show EventTile;
import '../section.dart' show EntityTile;
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
					onSubmitted: _setLabel
				),
				if (info != null) TextButton(
					child: const Text("information"),
					onPressed: () => _showEntities(
						[for (final item in info) EntityTile(
							title: item.name,
							pageBuilder: () => SubjectInfoPage(subject: _subject, item: item),
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
					action: _subject.unfollow
				) : EntityActionButton(
					text: "follow",
					action: _subject.follow
				),
				// todo: confirmation
				if (Cloud.role == Role.leader) EntityActionButton(
					text: "delete",
					action: () => Cloud.deleteSubject(_subject)
				)
			]
		);
	}

	void _setLabel(String label) {
		_subject.label = label;
		if (label.isEmpty) _nameField.text = _subject.name;
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
				floatingActionButton: FloatingActionButton(
					child: const Icon(Icons.add),
					onPressed: () => Navigator.of(context).push(MaterialPageRoute(
						builder: newEntityPageBuilder
					))
				)
			)
		));
	}
}


class SubjectInfoPage extends StatelessWidget {
	final Subject subject;
	final SubjectInfo item;
	final TextEditingController _nameField;
	final TextEditingController _contentField;

	SubjectInfoPage({
		required this.subject,
		required this.item
	}) :
		_nameField = TextEditingController(text: item.name),
		_contentField = TextEditingController(text: item.content);

	@override
	Widget build(BuildContext context) {
		return EntityPage(
			children: [
				InputField(
					controller: _nameField,
					name: "topic",
					onSubmitted: _setLabel
				),
				InputField(
					controller: _contentField,
					name: "information",
					onSubmitted: _setContent
				)
			],
			actions: Cloud.role == Role.ordinary ? null : [EntityActionButton(
				text: "delete",
				action: () {
					subject.info!.remove(item);
					Cloud.updateSubjectInfo(subject);
				}
			)]
		);
	}

	void _setLabel(String label) {
		item.label = label;
		if (label.isEmpty) _nameField.text = item.name;
	}

	void _setContent(String content) {
		if (content.isNotEmpty) {
			item.content = content;
			Cloud.updateSubjectInfo(subject);
		}
		else {
			_contentField.text = item.content;
		}
	}
}
