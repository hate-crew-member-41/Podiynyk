import 'package:flutter/material.dart';


class EntityPage extends StatelessWidget {
	const EntityPage({
		required this.children,
		this.actions = const <Widget>[]
	});

	final List<Widget> children;
	final List<Widget> actions;

	@override
	Widget build(BuildContext context) {
		return actions.isNotEmpty ? GestureDetector(
			onLongPress: () {
				Navigator.of(context).push(MaterialPageRoute(builder: (context) => Scaffold(
					body: Center(child: ListView(
					shrinkWrap: true,
					children: actions
				))
				)));
			},
			child: _builder(context)
		) : _builder(context);
	}

	Widget _builder(BuildContext context) => Scaffold(
		body: Center(child: ListView(
			shrinkWrap: true,
			children: children
		))
	);
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
			title: Text(text),
			onTap: () {
				Navigator.of(context).pop();
				action();
			}
		);
	}
}
