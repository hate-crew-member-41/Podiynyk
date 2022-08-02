import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:podiinyk/main.dart';
import 'package:podiinyk/core/domain/user/state.dart';


class JoiningPage extends HookConsumerWidget {
	const JoiningPage();

	@override
	Widget build(BuildContext context, WidgetRef ref) {
		final idField = useTextEditingController();

		return GestureDetector(
			onDoubleTap: () => _handleJoin(ref, idField.text),
			child: Scaffold(body: Column(
				mainAxisAlignment: MainAxisAlignment.center,
				crossAxisAlignment: CrossAxisAlignment.start,
				children: [
					const Text("Joining"),
					// do: textInputAction
					TextField(
						controller: idField,
						decoration: const InputDecoration(labelText: "id"),
					)
				]
			))
		);
	}

	Future<void> _handleJoin(WidgetRef ref, String id) async {
		// do: inform the user
		if (id.isEmpty) return;

		// do: inform the user
		await ref.read(userProvider.notifier).joinGroup(id);
		print("Identification: existing $id");
		ref.read(appStateProvider.notifier).state = AppState.home;
	}
}
