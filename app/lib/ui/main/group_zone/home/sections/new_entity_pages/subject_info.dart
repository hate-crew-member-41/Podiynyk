import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:podiynyk/storage/appearance.dart';
import 'package:podiynyk/storage/entities/subject_info.dart';

import 'package:podiynyk/ui/main/widgets/input_field.dart';

import '../providers.dart' show subjectInfoProvider;
import 'entity.dart';


class NewSubjectInfoPage extends HookConsumerWidget {
	const NewSubjectInfoPage();

	@override
	Widget build(BuildContext context, WidgetRef ref) {
		final nameField = useTextEditingController();
		final contentField = useTextEditingController();

		return NewEntityPage(
			entityOnAdd: () => _infoOnAdd(nameField.text, contentField.text),
			add: ref.read(subjectInfoProvider.notifier).add,
			children: [
				InputField(
					controller: nameField,
					name: "topic",
					style: Appearance.headlineText
				),
				InputField(
					controller: contentField,
					name: "content",
					multiline: true,
					style: Appearance.bodyText,
				)
			]
		);
	}

	SubjectInfo? _infoOnAdd(String name, String content) {
		if (name.isNotEmpty && content.isNotEmpty) return SubjectInfo(
			name: name,
			content: content
		);

		return null;
	}
}
