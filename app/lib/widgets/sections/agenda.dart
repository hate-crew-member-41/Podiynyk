import 'package:flutter/material.dart';

import 'package:podiynyk/storage/cloud.dart' show Cloud;
import 'package:podiynyk/storage/entities.dart' show Event;

import 'entity_pages/event.dart';
import 'new_entity_pages/event.dart';
import 'section.dart';


class AgendaSection extends ExtendableListSection<Event> {
	@override
	final name = "agenda";
	@override
	final icon = Icons.event_note;

	AgendaSection() {
		futureEntities = Cloud.events();
	}

	@override
	ListTile tile(BuildContext context, Event event) => ListTile(
		title: Text(event.name),
		subtitle: event.subject != null ? Text(event.subject!) : null,
		trailing: Text(event.date.dateRepr),
		onTap: () => Navigator.of(context).push(MaterialPageRoute(
			builder: (context) => EventPage(event)
		))
	);

	@override
	Widget addEntityButton(BuildContext context) => const AddEventButton();
}


class AddEventButton extends StatefulWidget {
	const AddEventButton();

	@override
	_AddEventButtonState createState() => _AddEventButtonState();
}

class _AddEventButtonState extends State<AddEventButton> {
	List<String>? _subjectNames;

	@override
	void initState() {
		Cloud.subjectNames().then((subjectNames) => setState(() => _subjectNames = subjectNames));
		super.initState();
	}

	@override
	Widget build(BuildContext context) {
		final isVisible = _subjectNames != null;

		return AnimatedOpacity(
			opacity: isVisible ? 1 : 0,
			duration: const Duration(milliseconds: 200),
			child: isVisible ? AddEntityButton(newEntityPage: NewEventPage(_subjectNames!)) : null
		);
	}
}
