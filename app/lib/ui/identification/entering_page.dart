import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:podiynyk/main.dart';
import 'package:podiynyk/storage/appearance.dart';
import 'package:podiynyk/storage/cloud.dart';
import 'package:podiynyk/storage/local.dart';

import '../leader_election.dart';
import '../home/home.dart';
import '../widgets/input_field.dart';
import 'page.dart';


class IdentificationEnteringPage extends HookConsumerWidget {
	const IdentificationEnteringPage();

	@override
	Widget build(BuildContext context, WidgetRef ref) {
		final nameField = useTextEditingController();

		return IdentificationPage(
			title: "Єднання",
			children: [
				const Text(
					"Уже чую, як вони стукають у двері. Піду їм відчиню. "
					"На випадок, якщо питатимуть тебе, як я це зрозумію?"
				).withPadding,
				InputField(controller: nameField, name: "ім'я")
			],
			onGoForward: () => _handleName(context, ref, nameField)
		);
	}

	Future<void> _handleName(BuildContext context, WidgetRef ref, TextEditingController nameField) async {
		final name = nameField.text;
		if (name.isEmpty) return;

		final messenger = ScaffoldMessenger.of(context);
		messenger.removeCurrentSnackBar();
		messenger.showSnackBar(SnackBar(
			duration: const Duration(days: 1),
			padding: EdgeInsets.zero,
			content: const Text("Зараз, я швиденько...").withPadding
		));
	
		if (await Cloud.nameIsUnique(name)) {
			await Local.initUser(name: name);
			await Cloud.enterGroup();

			messenger.hideCurrentSnackBar();
			ref.read(stateProvider.notifier).state = Local.userRole != null ? const Home() : const LeaderElection();
		}
		else {
			messenger.hideCurrentSnackBar();
			messenger.showSnackBar(SnackBar(
				duration: const Duration(seconds: 3),
				padding: EdgeInsets.zero,
				content: const Text("Тебе плутатимуть з іншою людиною на це ім'я 🙄").withPadding
			));

			nameField.clear();
		}
	}
}
