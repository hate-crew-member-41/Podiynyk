import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:podiinyk/main.dart';
import 'package:podiinyk/core/domain/user.dart';


class SharingPage extends ConsumerWidget {
	const SharingPage();

	@override
	Widget build(BuildContext context, WidgetRef ref) {
		final user = ref.watch(userProvider);
		final groupExists = user.groupId != null;
		
		if (groupExists) _copyId(user.groupId);

		return GestureDetector(
			onDoubleTap: () => ref.read(appStateProvider.notifier).state = AppState.home,
			onLongPress: () {
				if (groupExists) _copyId(user.groupId);
				// do: inform the user
			},
			child: Scaffold(
				body: !groupExists ?
					const Center(child: Text("Creating the group")) :
					Column(
						mainAxisAlignment: MainAxisAlignment.center,
						crossAxisAlignment: CrossAxisAlignment.start,
						children: const [
							Text("Group"),
							Text("Share the code on the clipboard.")
						]
					)
			)
		);
	}

	Future<void> _copyId(String? id) => Clipboard.setData(ClipboardData(text: id));
}
