import 'package:flutter/material.dart';

import 'package:podiynyk/storage/cloud.dart';
import 'package:podiynyk/storage/entities/student.dart';
import 'package:podiynyk/storage/entities/subject.dart';


import '../agenda.dart';
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
		final totalEventCount = subject.totalEventCount;
		final info = subject.info;
		final events = subject.events;

		return EntityPage(
			children: [
				TextField(
					controller: _nameField,
					decoration: const InputDecoration(hintText: "subject"),
					onSubmitted: (label) {},  // todo: add the label
				),
				if (totalEventCount != null) Text("${subject.totalEventCountRepr} so far"),
				if (info != null) TextButton(
					child: const Text("information"),
					onPressed: () => _showEntities(
						// todo: show the info item on tap
						[for (final item in info) ListTile(
							title: Text(item.topic)
						)],
						newEntityPageBuilder: (_) => NewSubjectInfoPage(subject)
					)
				),
				TextButton(
					child: Text(subject.eventCountRepr),
					onPressed: () => _showEntities(
						[for (final event in events!) EventTile(event, showSubject: false)],
						newEntityPageBuilder: (_) => NewEventPage.subjectEvent(subject)
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
