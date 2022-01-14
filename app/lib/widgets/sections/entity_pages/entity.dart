import 'package:flutter/material.dart';


class EntityPage extends StatelessWidget {
	final List<Widget> children;
	final List<Widget>? options;

	const EntityPage({
		required this.children,
		this.options
	});

	@override
	Widget build(BuildContext context) {
		return GestureDetector(
			onLongPress: options != null ? () {
				Navigator.of(context).push(MaterialPageRoute(builder: (context) => Scaffold(
					body: Column(
						mainAxisAlignment: MainAxisAlignment.center,
						crossAxisAlignment: CrossAxisAlignment.start,
						children: options!
					)
				)));
			} : null,
			child: Scaffold(
				body: Column(
					mainAxisAlignment: MainAxisAlignment.center,
					crossAxisAlignment: CrossAxisAlignment.start,
					children: children
				)
			)
		);
	}
}


class OptionButton extends StatelessWidget {
	final String text;
	final void Function() action;

	const OptionButton({
		required this.text,
		required this.action
	});

	@override
	Widget build(BuildContext context) {
		return TextButton(
			child: Text(text),
			onPressed: action,
			style: const ButtonStyle(alignment: Alignment.centerLeft)
		);
	}
}
