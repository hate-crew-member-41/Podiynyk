import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:podiynyk/storage/appearance.dart';
import 'package:podiynyk/storage/cloud.dart';
import 'package:podiynyk/storage/local.dart';
import 'package:podiynyk/storage/entities/student.dart' show Role;
import 'package:podiynyk/storage/entities/subject.dart';
import 'package:podiynyk/storage/entities/subject_info.dart';

import 'package:podiynyk/ui/widgets/input_field.dart';

import '../providers.dart';
import 'entity.dart';


class SubjectInfoPage extends HookConsumerWidget {
	SubjectInfoPage(this.info, {required this.subject}) :
		userIsOrdinary = Local.userRole == Role.ordinary;

	final SubjectInfo info;
	final ObjectRef<Subject> subject;
	final bool userIsOrdinary;

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
			actions: () => [
				if (!userIsOrdinary)
					EntityActionButton(
						text: "delete",
						action: () => _delete(context, ref)
					)
			],
			onClose: () => _onClose(ref, nameField.text, contentField.text)
		);
	}

	void _delete(BuildContext context, WidgetRef ref) {
		ref.read(subjectInfoNotifierProvider.notifier).delete(info);
		Navigator.of(context).pop();
	}

	void _onClose(WidgetRef ref, String nameRepr, String content) {
		final updated = SubjectInfo.modified(
			info,
			nameRepr: nameRepr,
			content: content
		);

		final contentChanged = updated.content != info.content;
		if (updated.nameRepr != info.nameRepr || contentChanged) {
			ref.read(subjectInfoNotifierProvider.notifier).updateItem(updated);

			if (contentChanged) {
				subject.value = Subject.modified(
					subject.value,
					info: ref.read(subjectInfoNotifierProvider)
				);

				Cloud.updateEntityDetails(subject.value);
			}
		}
	}
}
