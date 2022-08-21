import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:podiinyk/core/domain/user/state.dart';

import '../../widgets/bars/action_bar.dart';
import '../../widgets/bars/action_button.dart';
import 'section.dart';


class UserPage extends ConsumerWidget {
	const UserPage();

	@override
	Widget build(BuildContext context, WidgetRef ref) {
		final user = ref.watch(userProvider);
		final userNotifier = ref.watch(userProvider.notifier);

		return Center(child: ListView(
			shrinkWrap: true,
			children: [
				ActionBar(children: [ActionButton(
					icon: Icons.edit,
					action: () => ref.read(userIsEditingProvider.notifier).state = true
				)]),
				Text(user.student.fullName),
				if (user.info != null) Text(user.info!),
				ListTile(
					title: Text(user.groupId!),
					trailing: IconButton(
						icon: const Icon(Icons.clear),
						// do: confirmation
						onPressed: userNotifier.leaveGroup
					),
					// do: inform the user
					onTap: () => Clipboard.setData(ClipboardData(text: user.groupId))
				),
				Row(
					mainAxisAlignment: MainAxisAlignment.spaceAround,
					children: [
						IconButton(
							icon: const Icon(Icons.logout),
							// do: confirmation
							onPressed: userNotifier.signOut
						),
						IconButton(
							icon: const Icon(Icons.person_off),
							// do: confirmation
							onPressed: userNotifier.deleteAccount
						)
					]
				)
			]
		));
	}
}
