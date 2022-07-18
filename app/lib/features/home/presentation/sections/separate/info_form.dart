import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../domain/entities/entity.dart';
import '../../../domain/entities/info.dart';
import '../../../domain/providers/info.dart';


// do: TextField.textInputAction
class InfoForm extends HookConsumerWidget {
	const InfoForm();

	@override
	Widget build(BuildContext context, WidgetRef ref) {
		final nameField = useTextEditingController();
		final contentField = useTextEditingController();

		return GestureDetector(
			onDoubleTap: () => _handleAdd(context, ref, nameField.text, contentField.text),
			child: Scaffold(body: Column(
				mainAxisAlignment: MainAxisAlignment.center,
				children: [
					TextField(
						controller: nameField,
						decoration: const InputDecoration(labelText: 'name')
					),
					TextField(
						controller: contentField,
						decoration: const InputDecoration(labelText: 'content')
					)
				]
			))
		);
	}

	void _handleAdd(BuildContext context, WidgetRef ref, String name, String content) {
		// do: inform the user
		if (name.isEmpty || content.isEmpty) return;

		// think: await to show success or a failure
		ref.read(infoProvider.notifier).add(Info(
			id: Entity.newId(),
			name: name,
			content: content
		));
		Navigator.of(context).pop();
	}
}
