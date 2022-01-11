import 'package:flutter/material.dart';

import 'package:podiynyk/storage/entities.dart' show Subject;

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
		final hasEvents = widget._subject.events.isNotEmpty;

		return GestureDetector(
			onLongPress: () {},  // todo: the options
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
							onPressed: () => _showPage([
								for (final entry in info) Text(entry)]),
							child: const Text("information")
						),
						if (hasEvents) TextButton(
							onPressed: () => _showPage([
								for (final event in widget._subject.events) EventTile(event, showSubject: false)
							]),
							child: Text(widget._subject.eventCountRepr)
						)
					]
				)
			)
		);
	}

	void _showPage(List<Widget> items) {
		Navigator.of(context).push(MaterialPageRoute(builder: (context) => Scaffold(
			body: Center(child: ListView(
				shrinkWrap: true,
				children: items,
			))
		)));
	}
}
