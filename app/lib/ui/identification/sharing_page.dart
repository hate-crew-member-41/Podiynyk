import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:podiynyk/storage/appearance.dart';

import '../widgets/followed_page.dart';
import 'entering_page.dart';
import 'identification.dart';


class SharingPage extends HookConsumerWidget {
	const SharingPage({required this.id});

	final String id;

	@override
	Widget build(BuildContext context, WidgetRef ref) {
		useEffect(() {
			_copyId(context, inform: false);
			return null;
		}, const []);

		return FollowedPage(
			title: "Запрошення на вечорниці",
			children: [
				const Text(
					"Застосунок поклав у буфер обміну код. Поділися ним зі своїми одногрупниками.\n\n"
					"Якщо ти його загубиш, доторкнися та потримай знову."
				).withPadding
			],
			onGoForward: () => ref.read(pageProvider.notifier).state = const EnteringPage(),
			onLongPress: () => _copyId(context)
		);
	}

	Future<void> _copyId(BuildContext context, {bool inform = true}) async {
		await Clipboard.setData(ClipboardData(text: id));

		if (inform) ScaffoldMessenger.of(context).showSnackBar(SnackBar(
			duration: const Duration(seconds: 2),
			padding: EdgeInsets.zero,
			content: const Text("Поклав код у буфер та загорнув у хусточку.").withPadding
		));
	}
}
