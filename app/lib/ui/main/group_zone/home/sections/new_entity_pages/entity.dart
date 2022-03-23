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
	final Future<void>? Function() handleForm;

	@override
	Widget build(BuildContext context, WidgetRef ref) {
		return GestureDetector(
			onDoubleTap: () async {
				final adding = handleForm();
				if (adding != null) {
					Navigator.of(context).pop();

					final section = ref.read(sectionProvider) as EntitiesSection;
					ref.read(section.provider.notifier).update();
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
