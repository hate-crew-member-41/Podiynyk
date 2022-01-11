import 'package:flutter/material.dart';

import 'package:podiynyk/storage/cloud.dart' show Cloud;
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
			onLongPress: Cloud.role == Role.leader ?
				() => Navigator.of(context).push(MaterialPageRoute(builder: (context) => Scaffold(
					body: Column(
						mainAxisAlignment: MainAxisAlignment.center,
						crossAxisAlignment: CrossAxisAlignment.start,
						children: [
							_student.role == Role.ordinary ? TextButton(
								child: const Text("trust"),
								onPressed: () {},  // todo: implement
								style: const ButtonStyle(alignment: Alignment.centerLeft)
							) : TextButton(
								child: const Text("untrust"),
								onPressed: () {},  // todo: implement
								style: const ButtonStyle(alignment: Alignment.centerLeft)
							),
							TextButton(
								child: const Text("make the leader"),
								onPressed: () {},  // todo: implement
								style: const ButtonStyle(alignment: Alignment.centerLeft)
							)
						]
					)
				))) : null,
			child: Scaffold(
				body: Column(
					mainAxisAlignment: MainAxisAlignment.center,
					crossAxisAlignment: CrossAxisAlignment.start,
					children: [
						TextField(
							controller: _nameField,
							decoration: const InputDecoration(hintText: "name"),
							onSubmitted: (label) {},  // todo: add the label
						),
						if (_student.role != Role.ordinary) Text(_student.role.name)
					]
				)
			)
		);
	}
}
