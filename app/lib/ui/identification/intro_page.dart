import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:podiynyk/storage/appearance.dart';

import '../widgets/followed_page.dart';
import 'identification.dart';
import 'id_question_page.dart';


class IntroPage extends ConsumerWidget {
	const IntroPage();

	@override
	Widget build(BuildContext context, WidgetRef ref) {
		return FollowedPage(
			title: "Мої вітання",
			children: [
				const Text(
					"Місцетримайчик, що ся складає з коротенького опису цього застосунку. "
					"Ой у лузі червона калина досі стоїть.\n\n"
					"Я відмовився від кнопок \"далі\", тому коли тобі потрібна така, просто роби теп-теп."
				).withPadding
			],
			onGoForward: () => ref.read(pageProvider.notifier).state = const IdQuestionPage()
		);
	}
}
