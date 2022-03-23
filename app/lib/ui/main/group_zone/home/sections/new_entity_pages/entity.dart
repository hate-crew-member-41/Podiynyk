import 'package:flutter/material.dart';


class NewEntityPage extends StatelessWidget {
	const NewEntityPage({
		required this.children,
		required this.handleForm
	});

	final List<Widget> children;
	final Future<bool> Function() handleForm;

	@override
	Widget build(BuildContext context) {
		return GestureDetector(
			onDoubleTap: () async {
				final added = await handleForm();
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
