import 'package:flutter/material.dart';

import 'package:podiynyk/storage/cloud.dart' show Cloud;
import 'package:podiynyk/storage/entities.dart' show Student, Role, Compared;

import 'section.dart';


class GroupSection extends CloudListSection<Student> {
	@override
	final name = "group";
	@override
	final icon = Icons.people;

	const GroupSection();

	@override
	Future<List<Student>> get entities => Cloud.students();

	@override
	ListTile tile(Student student) => ListTile(
		title: Text(student.name),
		subtitle: student.role > Role.ordinary ? Text(student.role.name) : null
	);
}
