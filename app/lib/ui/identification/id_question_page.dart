import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:podiynyk/storage/appearance.dart';
import 'package:podiynyk/storage/cloud.dart';

import '../widgets/followed_page.dart';
import 'identification.dart';
import 'joining_page.dart';
import 'sharing_page.dart';


class IdQuestionPage extends ConsumerWidget {
	const IdQuestionPage();

	@override
	Widget build(BuildContext context, WidgetRef ref) {
		return FollowedPage(
			title: "У кожного свій шлях широкий",
			children: [
				const Text(
					"Якщо хтось із твоєї групи вже був тут і надав вам код, переходь далі.\n\n"
					"Якщо ти перший зі своєї групи, доторкнися та потримай."
				).withPadding
			],
			onGoForward: () => ref.read(pageProvider.notifier).state = const JoiningPage(),
			onLongPress: () => _handleUserIsFirst(context, ref)
		);
	}

	Future<void> _handleUserIsFirst(BuildContext context, WidgetRef ref) async {
		final messenger = ScaffoldMessenger.of(context);
		messenger.showSnackBar(SnackBar(
			duration: const Duration(days: 1),
			padding: EdgeInsets.zero,
			content: const Text("Зараз, я швиденько...").withPadding
		));

		final id = await Cloud.initGroup();
		messenger.hideCurrentSnackBar();
		ref.read(pageProvider.notifier).state = SharingPage(id: id);
	}
}
