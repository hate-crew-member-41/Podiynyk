import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:podiinyk/core/domain/id.dart';
import 'package:podiinyk/core/domain/user/state.dart';

import '../../../domain/entities/info.dart';
import '../../../domain/entities/subject.dart';
import '../../../domain/providers/info.dart';
import '../../../domain/providers/subjects.dart';


// do: TextField.textInputAction
class InfoForm extends HookConsumerWidget {
	const InfoForm({this.subject});

	final Subject? subject;

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

		// do: rewrite after defining EntitiesNotifier
		// think: await to show success or a failure
		final item = Info(
			id: newId(user: ref.read(userProvider)),
			name: name,
			subject: subject,
			content: content
		);
		if (subject != null) {
			ref.read(subjectDetailsProviders(subject!).notifier).addInfo(item);
		}
		else {
			ref.read(infoProvider.notifier).add(item);
		}

		Navigator.of(context).pop();
	}
}
