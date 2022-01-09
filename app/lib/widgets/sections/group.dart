import 'package:flutter/material.dart';

import 'package:podiynyk/storage/cloud.dart' show Cloud;
import 'package:podiynyk/storage/entities.dart' show Student, Role, Compared;
import 'package:podiynyk/storage/local.dart' show Local;

import 'section.dart';


class GroupSection extends CloudListSection<Student> {
	@override
	final name = "group";
	@override
	final icon = Icons.people;

	GroupSection() {
		futureEntities = Cloud.students();
	}

	@override
	ListTile tile(BuildContext context, Student student) {
		final labels = Local.studentLabels;

		return ListTile(
			title: Text(labels[student.name] ?? student.name),
			subtitle: student.role > Role.ordinary ? Text(student.role.name) : null,
			onTap: () => Navigator.of(context).push(MaterialPageRoute(
				builder: (context) => StudentPage(student)
			))
		);
	}
}


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
