import 'package:flutter/material.dart';

import 'package:podiynyk/storage/cloud.dart';
import 'package:podiynyk/storage/entities/student.dart';
import 'package:podiynyk/storage/entities/subject.dart';

import 'package:podiynyk/ui/main/widgets/fields.dart' show InputField;

import '../agenda.dart';
import '../new_entity_pages/event.dart';
import 'entity.dart';


class SubjectPage extends StatefulWidget {
	final Subject subject;
	final _nameField = TextEditingController();
	final _infoField = TextEditingController();

	SubjectPage(this.subject) {
		_nameField.text = subject.name;
	}

	@override
	State<SubjectPage> createState() => _SubjectPageState();
}

class _SubjectPageState extends State<SubjectPage> {
	@override
	void initState() {
		widget.subject.addDetails().whenComplete(() => setState(() {}));
		super.initState();
	}

	@override
	Widget build(BuildContext context) {
		final subject = widget.subject;
		final totalEventCount = subject.totalEventCount;
		final info = subject.info;
		final events = subject.events;

		final isLeader = Cloud.role == Role.leader;
		final canModify = (Cloud.role == Role.trusted && subject.isFollowed) || isLeader;

		return EntityPage(
			children: [
				TextField(
					controller: widget._nameField,
					decoration: const InputDecoration(hintText: "subject"),
					onSubmitted: (label) {},  // todo: add the label
				),
				if (totalEventCount != null) Text("${subject.totalEventCountRepr} so far"),
				if (info != null && info.isNotEmpty) TextButton(
					child: const Text("information"),
					onPressed: () => _showPage([
						for (final entry in info) Text(entry)  // todo: make them fields to enable editing
					])
				),
				if (events!.isNotEmpty) TextButton(
					child: Text(subject.eventCountRepr),
					onPressed: () => _showPage([
						for (final event in events) EventTile(event, showSubject: false)
					])
				)
			],
			actions: [
				if (canModify) EntityActionButton(
					text: "add an event",
					action: () => Navigator.of(context).push(MaterialPageRoute(
						builder: (_) => NewEventPage.subjectEvent(subject)
					))
				),
				if (canModify) EntityActionButton(
					text: "add information",
					action: () => Navigator.of(context).push(MaterialPageRoute(
						builder: (_) => GestureDetector(
							onDoubleTap: addInfo,
							child: Scaffold(
								body: Center(child: InputField(
									controller: widget._infoField,
									name: "information"
								))
							)
						)
					))
				),
				subject.isFollowed ? EntityActionButton(
					text: "unfollow",
					action: () => subject.unfollow()
				) : EntityActionButton(
					text: "follow",
					action: () => subject.follow()
				),
				// todo: confirmation
				if (isLeader) EntityActionButton(
					text: "delete",
					action: () => Cloud.deleteSubject(subject)
				)
			]
		);
	}

	void _showPage(List<Widget> children) {
		Navigator.of(context).push(MaterialPageRoute(builder: (context) => Scaffold(
			body: Column(
				mainAxisAlignment: MainAxisAlignment.center,
				crossAxisAlignment: CrossAxisAlignment.start,
				children: children
			)
		)));
	}

	void addInfo() {
		final subject = widget.subject;
		subject.info ??= [];

		subject.info!.add(widget._infoField.text);
		Cloud.updateSubjectInfo(widget.subject);
		Navigator.of(context).pop();
	}
}
