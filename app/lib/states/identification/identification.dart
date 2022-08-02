import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'joining_page.dart';
import 'question_page.dart';
import 'sharing_page.dart';


// do: add a confirmation page before creating a new group
enum IdentificationPage {
	question,
	sharing,
	joining
}

final identificationPageProvider = StateProvider.autoDispose<IdentificationPage>(
	(ref) => IdentificationPage.question
);

class Identification extends ConsumerWidget {
	const Identification();

	@override
	Widget build(BuildContext context, WidgetRef ref) {
		switch (ref.watch(identificationPageProvider)) {
			case IdentificationPage.question:
				return const QuestionPage();
			case IdentificationPage.sharing:
				return const SharingPage();
			case IdentificationPage.joining:
				return const JoiningPage();
		}
	}
}
