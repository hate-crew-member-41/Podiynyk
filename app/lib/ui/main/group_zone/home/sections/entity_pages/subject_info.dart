import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:podiynyk/storage/appearance.dart';
import 'package:podiynyk/storage/entities/subject_info.dart';
import 'package:podiynyk/ui/main/group_zone/home/sections/providers.dart';

import 'package:podiynyk/ui/main/widgets/input_field.dart';

import 'entity.dart';


class SubjectInfoPage extends HookConsumerWidget {
	final SubjectInfo info;

	const SubjectInfoPage(this.info);

	@override
	Widget build(BuildContext context, WidgetRef ref) {
		final nameField = useTextEditingController(text: info.nameRepr);
		final contentField = useTextEditingController(text: info.content);

		return EntityPage(
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
			],
			// actions: [
			// 	if (Cloud.userRole != Role.ordinary) EntityActionButton(
			// 		text: "delete",
			// 		action: info.delete
			// 	)
			// ],
			onClose: () {
				final current = SubjectInfo.modified(
					info: info,
					nameRepr: nameField.text,
					content: contentField.text
				);

				if (current.nameRepr != info.nameRepr) {
					ref.read(subjectInfoProvider.notifier).replace(info, current, preserveState: false);
				}
				else if (current.content != info.content) {
					ref.read(subjectInfoProvider.notifier).replace(info, current);
				}
			}
		);
	}
}
