import 'package:flutter/material.dart';

import 'package:podiynyk/storage/appearance.dart';


class EntityPage extends StatelessWidget {
	final List<Widget> children;
	final List<Widget> actions;

	const EntityPage({
		required this.children,
		this.actions = const <Widget>[]
	});

	@override
	Widget build(BuildContext context) {
		return GestureDetector(
			onLongPress: actions.isNotEmpty ? () {
				Navigator.of(context).push(MaterialPageRoute(builder: (context) => Scaffold(
					body: Center(child: ListView(
					shrinkWrap: true,
					children: actions
				))
				)));
			} : null,
			child: Scaffold(
				body: Center(child: ListView(
					shrinkWrap: true,
					children: children
				))
			)
		);
	}
}


class EntityActionButton extends StatelessWidget {
	final String text;
	final void Function() action;

	const EntityActionButton({
		required this.text,
		required this.action
	});

	@override
	Widget build(BuildContext context) {
		return ListTile(
			title: Text(text, style: Appearance.contentText),
			onTap: () {
				Navigator.of(context).pop();
				action();
			}
		);
	}
}
