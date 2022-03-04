import 'package:flutter/material.dart';


// idea: make it appear as a page to the right of the section,
// use PageView instead of FAD, remove the empty tiles in the sections
class NewEntityPage extends StatelessWidget {
	final List<Widget> children;
	final bool Function(BuildContext context) add;

	const NewEntityPage({
		required this.children,
		required this.add
	});

	@override
	Widget build(BuildContext context) {
		return GestureDetector(
			onDoubleTap: () {
				final added = add(context);
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
