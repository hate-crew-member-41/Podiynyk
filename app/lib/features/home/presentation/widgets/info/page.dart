import 'package:flutter/material.dart';

import '../../../domain/entities/info.dart';


class InfoPage extends StatelessWidget {
	const InfoPage(this.item);

	final Info item;

	@override
	Widget build(BuildContext context) {
		return Scaffold(body: Center(child: ListView(
			shrinkWrap: true,
			// do: take the values from the theme
			children: [
				const SizedBox(height: 56),
				Text(item.name),
				Text(item.content),
				const SizedBox(height: 56)
			]
		)));
	}
}
