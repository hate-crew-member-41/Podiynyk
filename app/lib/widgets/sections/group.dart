import 'package:flutter/material.dart';

import 'package:podiynyk/storage/cloud.dart' show Cloud;
import 'package:podiynyk/storage/entities.dart' show Student, Role;

import 'section.dart';
import 'entity_pages/student.dart';


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
		return ListTile(
			title: Text(student.name),
			subtitle: student.role == Role.ordinary ? null : Text(student.role.name),
			onTap: () => Navigator.of(context).push(MaterialPageRoute(
				builder: (context) => StudentPage(student)
			))
		);
	}
}
