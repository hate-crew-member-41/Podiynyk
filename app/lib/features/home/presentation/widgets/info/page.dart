import 'package:flutter/material.dart';

import '../../../domain/entities/info.dart';

import '../action_button.dart';
import '../bars/action_bar.dart';


class InfoPage extends StatelessWidget {
	const InfoPage(this.item);

	final Info item;

	@override
	Widget build(BuildContext context) {
		return Scaffold(body: SafeArea(child: Stack(children: [
			Center(child: ListView(
				shrinkWrap: true,
				// do: take the values from the theme
				children: [
					const SizedBox(height: 56),
					Text(item.name),
					Text(item.content),
					const SizedBox(height: 56)
				]
			)),
			ActionBar(children: [
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
