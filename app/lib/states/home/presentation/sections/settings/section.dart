import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:podiinyk/main.dart';
import 'package:podiinyk/core/domain/user/state.dart';

import '../../state.dart';
import '../../widgets/bars/section_bar.dart';


class SettingsSection extends ConsumerWidget {
	const SettingsSection();

	@override
	Widget build(BuildContext context, WidgetRef ref) {
		final user = ref.watch(userProvider);

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
							onPressed: () => _leaveGroup(ref)
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
								onPressed: () => _signOut(ref)
							),
							IconButton(
								icon: const Icon(Icons.delete),
								// do: delete the account
								onPressed: () => _deleteAccount(ref)
							)
						]
					)
				]
			))
		);
	}

	Future<void> _leaveGroup(WidgetRef ref) async {
		await ref.read(userProvider.notifier).leaveGroup();
		ref.read(appStateProvider.notifier).state = AppState.identification;
	}

	// think: move appState management from widgets to providers
	Future<void> _signOut(WidgetRef ref) async {
		await FirebaseAuth.instance.signOut();
		ref.read(appStateProvider.notifier).state = AppState.auth;
	}

	// do: confirmation, rename
	Future<void> _deleteAccount(WidgetRef ref) async {
		await ref.read(userProvider.notifier).deleteAccount();
		ref.read(appStateProvider.notifier).state = AppState.auth;
	}
}
