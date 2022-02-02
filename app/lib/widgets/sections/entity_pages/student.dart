import 'package:flutter/material.dart';

import 'package:podiynyk/storage/cloud.dart' show Cloud;
import 'package:podiynyk/storage/local.dart';
import 'package:podiynyk/storage/entities/student.dart';

import 'entity.dart';


class StudentPage extends StatelessWidget {
	final Student _student;
	final _nameField = TextEditingController();

	StudentPage(this._student) {
		_nameField.text = _student.name;
	}

	@override
	Widget build(BuildContext context) {
		return EntityPage(
			children: [
				TextField(
					controller: _nameField,
					decoration: const InputDecoration(hintText: "name"),
					onSubmitted: (label) {},  // todo: add the label
				),
				if (_student.role != Role.ordinary) Text(_student.role.name)
			],
			actions: Cloud.role != Role.leader || _student.name == Local.name ? null : [
				_student.role == Role.ordinary ? EntityActionButton(
					text: "trust",
					action: () => Cloud.setRole(_student, Role.trusted)
				) : EntityActionButton(
					text: "untrust",
					action: () => Cloud.setRole(_student, Role.ordinary)
				),
				EntityActionButton(
					text: "make the leader",
					action: () => Cloud.makeLeader(_student)
				)
			]
		);
	}
}
