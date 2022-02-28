import 'package:flutter/material.dart';


// todo: respond to actions (pop the actions page, display the new entity in the list, remove the deleted one, etc.)
// todo: apply all labels and changes onDoubleTap on the page instead of onSubmitted?
class EntityPage extends StatelessWidget {
	final List<Widget> children;
	final List<Widget>? actions;

	const EntityPage({
		required this.children,
		this.actions
	});

	@override
	Widget build(BuildContext context) {
		return GestureDetector(
			// todo: make an empty list mean no actions instead?
			onLongPress: actions != null ? () {
				Navigator.of(context).push(MaterialPageRoute(builder: (context) => Scaffold(
					body: Column(
						mainAxisAlignment: MainAxisAlignment.center,
						crossAxisAlignment: CrossAxisAlignment.start,
						children: actions!
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
			},
			style: const ButtonStyle(alignment: Alignment.centerLeft)
		);
	}
}
