import 'package:flutter/material.dart';

import 'package:podiynyk/storage/cloud.dart' show Cloud;
import 'package:podiynyk/storage/entities/student.dart';

import 'section.dart';
import 'entity_pages/student.dart';


class GroupSection extends CloudListSection<Student> {
	@override
	final name = "group";
	@override
	final icon = Icons.people;

	@override
	Future<List<Student>> get entitiesFuture => Cloud.students;

	@override
	Widget tile(BuildContext context, Student student) {
		return ListTile(
			title: Text(student.name),
			subtitle: student.role == Role.ordinary ? null : Text(student.role!.name),
			onTap: () => Navigator.of(context).push(MaterialPageRoute(
				builder: (context) => StudentPage(student)
			))
		);
	}
}
