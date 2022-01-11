import 'package:flutter/material.dart';

import 'package:podiynyk/storage/cloud.dart' show Cloud;
import 'package:podiynyk/storage/entities.dart' show Role, Subject;

import '../agenda.dart';


class SubjectPage extends StatefulWidget {
	final Subject _subject;
	final _nameField = TextEditingController();

	SubjectPage(this._subject) {
		_nameField.text = _subject.name;
	}

	@override
	State<SubjectPage> createState() => _SubjectPageState();
}

class _SubjectPageState extends State<SubjectPage> {
	@override
	void initState() {
		widget._subject.addDetails().whenComplete(() => setState(() {}));
		super.initState();
	}

	@override
	Widget build(BuildContext context) {
		final totalEventCount = widget._subject.totalEventCount;
		final info = widget._subject.info;
		final events = widget._subject.events;

		return GestureDetector(
			onLongPress: () => _showPage([
				TextButton(
					child: const Text("add an event"),
					onPressed: () {},  // todo: implement
					style: const ButtonStyle(alignment: Alignment.centerLeft)
				),
				TextButton(
					child: const Text("add information"),
					onPressed: () {},  // todo: implement
					style: const ButtonStyle(alignment: Alignment.centerLeft)
				),
				// todo: implement the following feature, add (follow / unfollow) buttons
				if (Cloud.role == Role.leader) TextButton(
					child: const Text("delete"),
					onPressed: () {},  // todo: implement
					style: const ButtonStyle(alignment: Alignment.centerLeft)
				)
			]),
			child: Scaffold(
				body: Column(
					mainAxisAlignment: MainAxisAlignment.center,
					crossAxisAlignment: CrossAxisAlignment.start,
					children: [
						TextField(
							controller: widget._nameField,
							decoration: const InputDecoration(hintText: "subject"),
							onSubmitted: (label) {},  // todo: add the label
						),
						if (totalEventCount != null) Text("${widget._subject.totalEventCountRepr} so far"),
						if (info != null) TextButton(
							child: const Text("information"),
							onPressed: () => _showPage([
								for (final entry in info) Text(entry)
							])
						),
						if (events.isNotEmpty) TextButton(
							child: Text(widget._subject.eventCountRepr),
							onPressed: () => _showPage([
								for (final event in events) EventTile(event, showSubject: false)
							])
						)
					]
				)
			)
		);
	}

	void _showPage(List<Widget> items) {
		Navigator.of(context).push(MaterialPageRoute(builder: (context) => Scaffold(
			body: Column(
				mainAxisAlignment: MainAxisAlignment.center,
				crossAxisAlignment: CrossAxisAlignment.start,
				children: items
			)
		)));
	}
}
