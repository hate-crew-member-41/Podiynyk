import 'package:flutter/material.dart';

import 'package:podiynyk/storage/cloud.dart';
import 'package:podiynyk/storage/entities/student.dart';

import 'section.dart';
import 'entity_pages/student.dart';


class GroupSectionCloudData extends CloudEntitiesSectionData<Student> {
	final students = Cloud.students;

	@override
	Future<List<Student>> get counted => students;
}


class GroupSection extends CloudEntitiesSection<GroupSectionCloudData, Student> {
	static const name = "group";
	static const icon = Icons.people;

	GroupSection() : super(GroupSectionCloudData());

	@override
	String get sectionName => name;
	@override
	IconData get sectionIcon => icon;

	@override
	Future<List<Student>> get entities => data.students;

	@override
	List<Widget> tiles(BuildContext context, List<Student> students) => [
		for (final student in students) EntityTile(
			title: student.nameRepr,
			subtitle: student.role == Role.ordinary ? null : student.role.name,
			pageBuilder: () => StudentPage(student)
		)
	];
}
