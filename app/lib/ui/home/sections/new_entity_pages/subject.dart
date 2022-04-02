import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:podiynyk/storage/appearance.dart';
import 'package:podiynyk/storage/entities/subject.dart';

import 'package:podiynyk/ui/widgets/input_field.dart';

import '../providers.dart' show subjectsNotifierProvider;
import 'entity.dart';


class NewSubjectPage extends HookConsumerWidget {
	@override
	Widget build(BuildContext context, WidgetRef ref) {
		final nameField = useTextEditingController();

		return NewEntityPage(
			entityOnAdd: () => _subjectOnAdd(ref, nameField.text),
			add: ref.read(subjectsNotifierProvider.notifier).add,
			children: [
				InputField(
					controller: nameField,
					name: "name",
					style: Appearance.headlineText
				)
			]
		);
	}

	Subject? _subjectOnAdd(WidgetRef ref, String name) {
		if (name.isNotEmpty) return Subject(name: name);
		return null;
	}
}
