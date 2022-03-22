import 'package:flutter/material.dart';

import 'package:podiynyk/storage/cloud.dart';
import 'package:podiynyk/storage/entities/student.dart';

import 'section.dart';
import 'entity_pages/student.dart';


class GroupSectionData extends CloudEntitiesSectionData<Student> {
	@override
	Future<List<Student>> get entities => Cloud.students;
}


class GroupSection extends CloudEntitiesSection<GroupSectionData, Student> {
	static const name = "group";
	static const icon = Icons.people;

	@override
	String get sectionName => name;
	@override
	IconData get sectionIcon => icon;

	@override
	GroupSectionData get data => GroupSectionData();

	@override
	List<Widget> tiles(BuildContext context, List<Student> students) => [
		for (final student in students) EntityTile(
			title: student.nameRepr,
			subtitle: student.role == Role.ordinary ? null : student.role.name,
			pageBuilder: () => StudentPage(student)
		)
	];
}
