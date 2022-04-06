import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:podiynyk/storage/appearance.dart';

import '../widgets/followed_page.dart';
import 'candidates_page.dart';
import 'leader_election.dart';


class LeaderElectionIntroPage extends ConsumerWidget {
	const LeaderElectionIntroPage();

	@override
	Widget build(BuildContext context, WidgetRef ref) {
		return FollowedPage(
			title: "Вже майже",
			children: [
				const Text(
					"Зараз ти побачиш оновлюваний список одногрупників, які вже також тут. "
					"Коли у ньому з'явиться староста, натисни на неї.\n\n"
					"Якщо староста це ти, влаштовуйся зручно та дивись, як натискають на тебе."
				).withPadding
			],
			onGoForward: () => ref.read(pageProvider.notifier).state = const CandidatesPage(),
		);
	}
}
