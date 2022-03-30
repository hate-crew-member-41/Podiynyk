import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:podiynyk/storage/appearance.dart';
import 'package:podiynyk/storage/entities/subject_info.dart';

import 'package:podiynyk/ui/main/widgets/input_field.dart';

import 'entity.dart';


class SubjectInfoPage extends HookWidget {
	final SubjectInfo info;

	const SubjectInfoPage(this.info);

	@override
	Widget build(BuildContext context) {
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
			// sectionShouldRebuild: () {
			// 	bool changed = false;

			// 	if (nameField.text != info.nameRepr) {
			// 		info.nameRepr = nameField.text;
			// 		changed = true;
			// 	}

			// 	if (contentField.text != info.content) info.content = contentField.text;

			// 	return changed;
			// }
		);
	}
}
