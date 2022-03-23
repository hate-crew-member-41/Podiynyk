import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../agenda.dart';


class NewEntityPage extends ConsumerWidget {
	const NewEntityPage({
		required this.children,
		required this.handleForm
	});

	final List<Widget> children;
	final Future<bool> Function() handleForm;

	@override
	Widget build(BuildContext context, WidgetRef ref) {
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
