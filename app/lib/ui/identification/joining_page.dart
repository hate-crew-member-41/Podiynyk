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


class IdentificationJoiningPage extends HookConsumerWidget {
	const IdentificationJoiningPage();

	@override
	Widget build(BuildContext context, WidgetRef ref) {
		final idField = useTextEditingController();
		final nameField = useTextEditingController();

		return IdentificationPage(
			title: "Приєднання",
			children: [
				InputField(controller: idField, name: "код"),
				InputField(controller: nameField, name: "ім'я")
			],
			onGoForward: () => _handleForm(context, ref, idField, nameField)
		);
	}

	Future<void> _handleForm(
		BuildContext context,
		WidgetRef ref,
		TextEditingController idField,
		TextEditingController nameField
	) async {
		final id = idField.text, name = nameField.text;
		if (id.isEmpty || name.isEmpty) return;

		final messenger = ScaffoldMessenger.of(context);
		messenger.removeCurrentSnackBar();
		messenger.showSnackBar(SnackBar(
			duration: const Duration(days: 1),
			padding: EdgeInsets.zero,
			content: const Text("Зараз, я швиденько...").withPadding
		));

		final nameIsUnique = await Cloud.nameIsUniqueInGroup(id, name);

		if (nameIsUnique == true) {
			Local.groupId = id;
			await Local.initUser(name: name);
			await Cloud.enterGroup();

			messenger.removeCurrentSnackBar();
			ref.read(stateProvider.notifier).state = Local.userRole != null ? const Home() : const LeaderElection();
		}
		else {
			messenger.hideCurrentSnackBar();

			late final String text;

			if (nameIsUnique == false) {
				text = "Тебе плутатимуть з іншою людиною 🙄";
				nameField.clear();
			}
			else {
				text = "Цього коду не існує 🙄";
				idField.clear();
			}

			messenger.showSnackBar(SnackBar(
				duration: const Duration(seconds: 2),
				padding: EdgeInsets.zero,
				content: Text(text).withPadding
			));
		}
	}
}
