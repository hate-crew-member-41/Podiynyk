import 'package:flutter/material.dart';

import '../../domain/entities/event.dart';


class EventTile extends StatelessWidget {
	const EventTile(this.event);

	final Event event;

	@override
	Widget build(BuildContext context) {
		return ListTile(
			title: Text(event.name),
			subtitle: event.subject != null ? Text(event.subject!.name) : null,
			trailing: Text(event.date.shortRepr)
		);
	}
}
