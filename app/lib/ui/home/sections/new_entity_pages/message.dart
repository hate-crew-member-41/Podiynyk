import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:podiynyk/storage/appearance.dart';
import 'package:podiynyk/storage/entities/message.dart';

import 'package:podiynyk/ui/widgets/input_field.dart';

import '../providers.dart' show messagesNotifierProvider;
import 'entity.dart';


class NewMessagePage extends HookConsumerWidget {
	@override
	Widget build(BuildContext context, WidgetRef ref) {
		final nameField = useTextEditingController();
		final contentField = useTextEditingController();

		return NewEntityPage(
			entityOnAdd: () => _messageOnAdd(nameField.text, contentField.text),
			add: ref.read(messagesNotifierProvider.notifier).add,
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

	Message? _messageOnAdd(String name, String content) {
		if (name.isNotEmpty && content.isNotEmpty) return Message(
			name: name,
			content: content
		);

		return null;
	}
}
