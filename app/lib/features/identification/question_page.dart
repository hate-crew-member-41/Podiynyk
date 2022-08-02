import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:podiinyk/core/domain/user.dart';
import 'identification.dart';


class QuestionPage extends ConsumerWidget {
	const QuestionPage();

	@override
	Widget build(BuildContext context, WidgetRef ref) {
		final page = ref.watch(identificationPageProvider.notifier);

		return GestureDetector(
			onLongPress: () {
				ref.read(userProvider.notifier).enterNewGroup();
				page.state = IdentificationPage.sharing;
			},
			onDoubleTap: () => page.state = IdentificationPage.entering,
			child: Scaffold(body: Column(
				mainAxisAlignment: MainAxisAlignment.center,
				crossAxisAlignment: CrossAxisAlignment.start,
				children: const [
					Text("Group"),
					Text("Tap twice to join.\nLong press to create.")
				]
			))
		);
	}
}
