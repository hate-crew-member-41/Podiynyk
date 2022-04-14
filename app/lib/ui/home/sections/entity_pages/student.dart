import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:podiynyk/storage/appearance.dart';
import 'package:podiynyk/storage/cloud.dart';
import 'package:podiynyk/storage/local.dart';
import 'package:podiynyk/storage/entities/student.dart';

import 'package:podiynyk/ui/widgets/input_field.dart';

import '../providers.dart' show studentsNotifierProvider;
import 'entity.dart';


class StudentPage extends HookConsumerWidget {
	StudentPage(this.student) :
		studentIsOrdinary = student.role == Role.ordinary;

	final Student student;
	final bool studentIsOrdinary;

	@override
	Widget build(BuildContext context, WidgetRef ref) {
		final nameField = useTextEditingController(text: student.nameRepr);
		final role = useRef(student.role!);

		return EntityPage(
			children: [
				InputField(
					controller: nameField,
					name: "name",
					style: Appearance.headlineText
				),
				if (student.role != Role.ordinary)
					Text(
						student.role!.name,
						style: Appearance.largeTitleText
					).withPadding
			],
			actions: Local.userRole != Role.leader || student.name == Local.userName ?
				() => const [] :
				() => [
					studentIsOrdinary ?
						EntityActionButton(
							text: "trust",
							action: () => role.value = Role.trusted
						) :
						EntityActionButton(
							text: "untrust",
							action: () => role.value = Role.ordinary
						),
					EntityActionButton(
						text: "make the leader",
						action: () => Cloud.makeLeader(student)
					)
				],
			onClose: () => _onClose(ref, nameField.text, role.value)
		);
	}

	void _onClose(WidgetRef ref, String nameRepr, Role role) {
		final updated = Student.modified(
			student: student,
			nameRepr: nameRepr,
			role: role
		);

		bool changed = false;

		if (updated.role != student.role) {
			Cloud.updateEntity(updated);
			changed = true;
		}

		if (changed) {
			ref.read(studentsNotifierProvider.notifier).updateEntity(updated);
		}
	}
}
