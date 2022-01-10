import 'package:flutter/material.dart';


class NewEntityPage extends StatelessWidget {
	final List<Widget> children;
	final void Function(BuildContext context) addEntity;

	const NewEntityPage({
		required this.children,
		required this.addEntity
	});

	@override
	Widget build(BuildContext context) {
		return GestureDetector(
			// todo: display the new entity in the list (consider updating the list instead of rebuilding to prevent unnecessary)
			onDoubleTap: () => addEntity(context),
			child: Scaffold(
				body: Center(child: ListView(
					shrinkWrap: true,
					children: children
				))
			)
		);
	}
}
