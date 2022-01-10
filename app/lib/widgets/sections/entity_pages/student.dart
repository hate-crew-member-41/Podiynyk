import 'package:flutter/material.dart';

import 'package:podiynyk/storage/entities.dart' show Student, Role;


class StudentPage extends StatelessWidget {
	final Student _student;
	final _nameField = TextEditingController();

	StudentPage(this._student) {
		_nameField.text = _student.name;
	}

	@override
	Widget build(BuildContext context) {
		return GestureDetector(
			onLongPress: () {},  // todo: the options
			child: Scaffold(
				body: Column(
					mainAxisAlignment: MainAxisAlignment.center,
					crossAxisAlignment: CrossAxisAlignment.start,
					children: [
						TextField(  // todo: adding a label
							controller: _nameField,
							decoration: const InputDecoration(hintText: "name"),
						),
						if (_student.role != Role.ordinary) Text(_student.role.name)
					]
				)
			)
		);
	}
}
