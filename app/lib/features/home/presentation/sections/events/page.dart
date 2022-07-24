import 'package:flutter/material.dart';

import '../../../domain/entities/event.dart';

import '../../widgets/action_button.dart';
import '../../widgets/bars/action_bar.dart';


// think: define EntityPage
class EventPage extends StatelessWidget {
	const EventPage(this.event);

	final Event event;

	@override
	Widget build(BuildContext context) {
		return Scaffold(body: SafeArea(child: Stack(children: [
			Center(child: ListView(
				shrinkWrap: true,
				// do: take the values from the theme
				children: [
					const SizedBox(height: 56),
					Text(event.name),
					if (event.subject != null) Text(event.subject!.name),
					Text(event.date.repr),
					if (event.note != null) ...[
						const SizedBox(height: 56),
						Text(event.note!)
					],
					const SizedBox(height: 56)
				]
			)),
			ActionBar(children: [
				ActionButton(
					icon: Icons.done,  // Icons.undo
					action: () {}
				),
				ActionButton(
					icon: Icons.edit,
					action: () {}
				),
				ActionButton(
					icon: Icons.delete,
					action: () {}
				)
			])
		])));
	}
}
