import 'package:flutter/material.dart';


class NewEntityPage extends StatelessWidget {
	const NewEntityPage({
		required this.children,
		required this.add
	});

	final List<Widget> children;
	final bool Function() add;

	@override
	Widget build(BuildContext context) {
		return GestureDetector(
			onDoubleTap: () {
				final added = add();
				if (added) Navigator.of(context).pop();
			},
			child: Scaffold(
				body: Center(child: ListView(
					shrinkWrap: true,
					children: children
				))
			)
		);
	}
}
