import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:podiinyk/core/domain/user/state.dart';

import '../../state.dart';
import '../../widgets/bars/section_bar.dart';


class MeSection extends ConsumerWidget {
	const MeSection();

	@override
	Widget build(BuildContext context, WidgetRef ref) {
		final user = ref.watch(userProvider);
		final userNotifier = ref.watch(userProvider.notifier);

		return Scaffold(
			appBar: const SectionBar(
				section: Section.settings,
			),
			body: Center(child: ListView(
				shrinkWrap: true,
				children: [
					Text(user.student.fullName),
					const SizedBox(height: 56),
					ListTile(
						title: Text(user.groupId!),
						trailing: IconButton(
							icon: const Icon(Icons.backspace),
							// do: confirmation
							onPressed: userNotifier.leaveGroup
						),
						// do: inform the user
						onTap: () => Clipboard.setData(ClipboardData(text: user.groupId))
					),
					const SizedBox(height: 56),
					Row(
						mainAxisAlignment: MainAxisAlignment.spaceAround,
						children: [
							IconButton(
								icon: const Icon(Icons.compare_arrows),
								// do: confirmation
								onPressed: userNotifier.signOut
							),
							IconButton(
								icon: const Icon(Icons.delete),
								// do: confirmation
								onPressed: userNotifier.deleteAccount
							)
						]
					)
				]
			))
		);
	}
}
