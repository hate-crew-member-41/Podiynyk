import 'package:flutter/material.dart';

import 'package:podiynyk/storage/cloud.dart';
import 'package:podiynyk/storage/entities/student.dart';
import 'package:podiynyk/storage/entities/subject.dart';


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
		_subject = widget.subject;
		_nameField.text = _subject.name;
		_subject.addDetails().whenComplete(() => setState(() {}));
		super.initState();
	}

	@override
	Widget build(BuildContext context) {
		final info = _subject.info;
		final events = _subject.events;

		return EntityPage(
			children: [
				TextField(
					controller: _nameField,
					decoration: const InputDecoration(hintText: "subject"),
					onSubmitted: _setLabel
				),
				if (info != null) TextButton(
					child: const Text("information"),
					onPressed: () => _showEntities(
						// todo: show the info item on tap
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
	final TextEditingController _topicField;
	final TextEditingController _infoField;


	SubjectInfoPage({
		required this.subject,
		required this.item
	}) :
		_topicField = TextEditingController(text: item.name),
		_infoField = TextEditingController(text: item.info);

	@override
	Widget build(BuildContext context) {
		return EntityPage(
			children: [
				TextField(
					controller: _topicField,
					decoration: const InputDecoration(hintText: "topic"),
					onSubmitted: _setLabel
				),
				TextField(
					controller: _infoField,
					decoration: const InputDecoration(hintText: "information"),
					onSubmitted: _setInfo
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
		if (label.isEmpty) _topicField.text = item.name;
	}

	void _setInfo(String info) {
		if (info.isNotEmpty) {
			item.info = info;
			Cloud.updateSubjectInfo(subject);
		}
		else {
			_infoField.text = item.info;
		}
	}
}
