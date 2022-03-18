import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:podiynyk/storage/appearance.dart';
import 'package:podiynyk/storage/cloud.dart';
import 'package:podiynyk/storage/local.dart';
import 'package:podiynyk/storage/entities/student.dart';

import 'package:podiynyk/ui/main/common/fields.dart' show InputField;

import 'entity.dart';


class StudentPage extends HookWidget {
	final Student student;

	const StudentPage(this.student);

	@override
	Widget build(BuildContext context) {
		final nameField = useTextEditingController(text: student.nameRepr);

		useEffect(() => () => student.label = nameField.text);

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
				).withPadding
			],
			actions: Cloud.userRole != Role.leader || student.name == Local.userName ? [] : [
				student.role == Role.ordinary ? EntityActionButton(
					text: "trust",
					action: () => student.role = Role.trusted
				) : EntityActionButton(
					text: "untrust",
					action: () => student.role = Role.ordinary
				),
				EntityActionButton(
					text: "make the leader",
					action: () => Cloud.makeLeader(student)
				)
			]
		);
	}
}
