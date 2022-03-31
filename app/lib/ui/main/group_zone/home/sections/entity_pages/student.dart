import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:podiynyk/storage/appearance.dart';
import 'package:podiynyk/storage/entities/student.dart';

import 'package:podiynyk/ui/main/widgets/input_field.dart';

import '../providers.dart' show studentsNotifierProvider;
import 'entity.dart';


class StudentPage extends HookConsumerWidget {
	const StudentPage(this.student);

	final Student student;

	@override
	Widget build(BuildContext context, WidgetRef ref) {
		final nameField = useTextEditingController(text: student.nameRepr);
		final role = useRef(student.role);

		return EntityPage(
			children: [
				InputField(
					controller: nameField,
					name: "name",
					style: Appearance.headlineText
				),
				if (student.role != Role.ordinary) Text(
					student.role!.name,
					style: Appearance.largeTitleText
				).withPadding()
			],
			// actions: Cloud.userRole != Role.leader || student.name == Local.userName ? [] : [
			// 	student.role == Role.ordinary ? EntityActionButton(
			// 		text: "trust",
			// 		action: () => role.value = Role.trusted
			// 	) : EntityActionButton(
			// 		text: "untrust",
			// 		action: () => role.value = Role.ordinary
			// 	),
			// 	EntityActionButton(
			// 		text: "make the leader",
			// 		action: () => Cloud.makeLeader(student)
			// 	)
			// ],
			onClose: () {
				final current = Student.modified(
					student: student,
					nameRepr: nameField.text,
					role: role.value
				);

				if (current.nameRepr != student.nameRepr || current.role != student.role) {
					ref.read(studentsNotifierProvider.notifier).replace(student, current);
				}
			}
		);
	}
}
