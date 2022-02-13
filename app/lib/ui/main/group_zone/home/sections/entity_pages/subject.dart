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
	final _nameField = TextEditingController();

	@override
	void initState() {
		_nameField.text = widget.subject.name;
		widget.subject.addDetails().whenComplete(() => setState(() {}));
		super.initState();
	}

	@override
	Widget build(BuildContext context) {
		final subject = widget.subject;
		final info = subject.info;
		final events = subject.events;

		return EntityPage(
			children: [
				TextField(
					controller: _nameField,
					decoration: const InputDecoration(hintText: "subject"),
					onSubmitted: (label) {},  // todo: add the label
				),
				if (info != null) TextButton(
					child: const Text("information"),
					onPressed: () => _showEntities(
						// todo: show the info item on tap
						[for (final item in info) EntityTile(
							title: item.topic,
							pageBuilder: () => SubjectInfoPage(subject: subject, info: item),
						)],
						newEntityPageBuilder: (_) => NewSubjectInfoPage(subject)
					)
				),
				TextButton(
					child: Text(subject.eventCountRepr),
					onPressed: () => _showEntities(
						[for (final event in events) EventTile(event, showSubject: false)],
						newEntityPageBuilder: (_) => NewEventPage.subjectEvent(subject.name)
					)
				)
			],
			actions: [
				subject.isFollowed ? EntityActionButton(
					text: "unfollow",
					action: subject.unfollow
				) : EntityActionButton(
					text: "follow",
					action: subject.follow
				),
				// todo: confirmation
				if (Cloud.role == Role.leader) EntityActionButton(
					text: "delete",
					action: () => Cloud.deleteSubject(subject)
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
	final SubjectInfo info;
	final TextEditingController _topicField;
	final TextEditingController _infoField;


	SubjectInfoPage({
		required this.subject,
		required this.info
	}) :
		_topicField = TextEditingController(text: info.topic),
		_infoField = TextEditingController(text: info.info);

	@override
	Widget build(BuildContext context) {
		return EntityPage(
			children: [
				TextField(
					controller: _topicField,
					decoration: const InputDecoration(hintText: "topic"),
					onSubmitted: (label) {},  // todo: add the label
				),
				TextField(
					controller: _infoField,
					decoration: const InputDecoration(hintText: "information"),
					onSubmitted: (label) {},  // todo: change the info
				)
			],
			actions: Cloud.role == Role.ordinary ? null : [EntityActionButton(
				text: "delete",
				action: () {
					subject.info!.remove(info);
					Cloud.updateSubjectInfo(subject);
				}
			)]
		);
	}
}
