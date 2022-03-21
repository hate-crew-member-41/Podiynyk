import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:podiynyk/storage/appearance.dart';
import 'package:podiynyk/storage/cloud.dart';
import 'package:podiynyk/storage/local.dart';
import 'package:podiynyk/storage/entities/student.dart';

import 'package:podiynyk/ui/main/common/fields.dart' show InputField;

import 'entity.dart';


class StudentPage extends HookWidget {
	const StudentPage(this.student);

	final Student student;

	@override
	Widget build(BuildContext context) {
		final nameField = useTextEditingController(text: student.nameRepr);
		final role = useRef(student.role);

		useEffect(() => () {
			if (nameField.text != student.nameRepr) student.nameRepr = nameField.text;
			if (role.value != student.role) student.role = role.value;
		});

		return EntityPage(
			children: [
				InputField(
					controller: nameField,
					name: "name",
					style: Appearance.headlineText
				),
				if (student.role != Role.ordinary) Text(
					student.role.name,
					style: Appearance.largeTitleText
				).withPadding()
			],
			actions: Cloud.userRole != Role.leader || student.name == Local.userName ? [] : [
				student.role == Role.ordinary ? EntityActionButton(
					text: "trust",
					action: () => role.value = Role.trusted
				) : EntityActionButton(
					text: "untrust",
					action: () => role.value = Role.ordinary
				),
				EntityActionButton(
					text: "make the leader",
					action: () => Cloud.makeLeader(student)
				)
			]
		);
	}
}
