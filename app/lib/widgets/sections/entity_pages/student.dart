import 'package:flutter/material.dart';

import 'package:podiynyk/storage/entities.dart' show Student;
import 'package:podiynyk/storage/local.dart';


class StudentPage extends StatelessWidget {
	final Student _student;
	final _nameField = TextEditingController();

	StudentPage(this._student) {
		_nameField.text = _student.name;
	}

	@override
	Widget build(BuildContext context) {
		return GestureDetector(
			onLongPress: () {},  // todo: show the options
			child: Scaffold(
				body: Column(
					mainAxisAlignment: MainAxisAlignment.center,
					crossAxisAlignment: CrossAxisAlignment.start,
					children: [
						TextField(
							controller: _nameField,
							decoration: const InputDecoration(hintText: "name"),
							onSubmitted: _addLabel,
						),
						Text(_student.role.name)
					]
				)
			)
		);
	}

	void _addLabel(String label) {
		if (label != _student.name) Local.addStudentLabel(_student.name, label);
	}
}
