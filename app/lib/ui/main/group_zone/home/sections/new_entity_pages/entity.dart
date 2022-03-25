import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../home.dart';
import '../section.dart';


class NewEntityPage extends ConsumerWidget {
	const NewEntityPage({
		required this.children,
		required this.handleForm
	});

	final List<Widget> children;
	final bool Function() handleForm;

	@override
	Widget build(BuildContext context, WidgetRef ref) {
		return GestureDetector(
			onDoubleTap: () async {
				if (handleForm()) {
					Navigator.of(context).pop();
					(ref.read(sectionProvider) as EntitiesSection).update(ref);
				}
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
