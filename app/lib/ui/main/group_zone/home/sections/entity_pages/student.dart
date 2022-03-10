import 'package:flutter/material.dart';

import 'package:podiynyk/storage/cloud.dart';
import 'package:podiynyk/storage/local.dart';
import 'package:podiynyk/storage/entities/student.dart';

import 'package:podiynyk/ui/main/common/fields.dart' show InputField;

import 'entity.dart';


class StudentPage extends StatefulWidget {
	final Student student;

	const StudentPage(this.student);

	@override
	State<StudentPage> createState() => _StudentPageState();
}

class _StudentPageState extends State<StudentPage> {
	late final Student _student;
	final _nameField = TextEditingController();

	@override
	void initState() {
		super.initState();
		_student = widget.student;
		_nameField.text = _student.nameRepr;
	}

	@override
	Widget build(BuildContext context) {
		return EntityPage(
			children: [
				InputField(
					controller: _nameField,
					name: "name",
				),
				if (_student.role != Role.ordinary) Text(_student.role.name)
			],
			actions: Cloud.role != Role.leader || _student.name == Local.name ? [] : [
				_student.role == Role.ordinary ? EntityActionButton(
					text: "trust",
					action: () => _student.role = Role.trusted
				) : EntityActionButton(
					text: "untrust",
					action: () => _student.role = Role.ordinary
				),
				EntityActionButton(
					text: "make the leader",
					action: () => Cloud.makeLeader(_student)
				)
			]
		);
	}

	// todo: changing own name
	@override
	void dispose() {
		_student.label = _nameField.text;
		super.dispose();
	}
}
