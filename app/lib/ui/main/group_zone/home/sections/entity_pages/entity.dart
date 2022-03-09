import 'package:flutter/material.dart';


// todo: make detail entity fields late non-nullable, add [hasDetails] field
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
					body: Column(
						mainAxisAlignment: MainAxisAlignment.center,
						crossAxisAlignment: CrossAxisAlignment.start,
						children: actions
					)
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
		return TextButton(
			child: Text(text),
			onPressed: () {
				Navigator.of(context).pop();
				action();
			}
		);
	}
}
