import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:podiinyk/core/domain/user/state.dart';
import 'package:podiinyk/core/domain/user/user.dart';

import 'section.dart';


class UserEditingPage extends HookConsumerWidget {
	const UserEditingPage();

	@override
	Widget build(BuildContext context, WidgetRef ref) {
		final user = ref.watch(userProvider);

		final firstNameField = useTextEditingController(text: user.firstName);
		final lastNameField = useTextEditingController(text: user.lastName);
		final infoField = useTextEditingController(text: user.info);

		// do: make the whole page sensitive to gestures
		return GestureDetector(
			onDoubleTap: () => _handleUpdate(ref, user, firstNameField.text, lastNameField.text, infoField.text),
			child: Center(child: ListView(
				shrinkWrap: true,
				children: [
					Row(children: [
						Expanded(child: TextField(
							controller: firstNameField,
							decoration: const InputDecoration(labelText: 'first')
						)),
						Expanded(child: TextField(
							controller: lastNameField,
							decoration: const InputDecoration(labelText: 'last')
						))
					]),
					TextField(
						controller: infoField,
						decoration: const InputDecoration(labelText: 'info')
					)
				]
			))
		);
	}

	Future<void> _handleUpdate(
		WidgetRef ref,
		User user,
		String firstName,
		String lastName,
		String rawInfo
	) async {
		final info = rawInfo.isNotEmpty ? rawInfo : null;
		final changed = firstName != user.firstName || lastName != user.lastName || info != user.info;

		if (changed) {
			await ref.read(userProvider.notifier).update(
				firstName: firstName,
				lastName: lastName,
				info: info
			);
		}

		ref.read(userIsEditingProvider.notifier).state = false;
	}
}
