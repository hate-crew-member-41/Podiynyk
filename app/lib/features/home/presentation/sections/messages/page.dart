import 'package:flutter/material.dart';

import '../../../domain/entities/message.dart';

import '../../widgets/action_button.dart';
import '../../widgets/bars/action_bar.dart';


class MessagePage extends StatelessWidget {
	const MessagePage(this.message);

	final Message message;

	@override
	Widget build(BuildContext context) {
		return Scaffold(body: SafeArea(child: Stack(children: [
			Center(child: ListView(
				shrinkWrap: true,
				// do: take the values from the theme
				children: [
					const SizedBox(height: 56),
					Text(message.name),
					Text(message.author.fullName),
					Text(message.date.repr),
					const SizedBox(height: 56),
					Text(message.content),
					const SizedBox(height: 56)
				]
			)),
			if (message.isByUser) ActionBar(children: [
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
