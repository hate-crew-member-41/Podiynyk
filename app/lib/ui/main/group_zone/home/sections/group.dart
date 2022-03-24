import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:podiynyk/storage/cloud.dart';
import 'package:podiynyk/storage/entities/student.dart';

import 'section.dart';
import 'entity_pages/student.dart';


class StudentsNotifier extends EntitiesNotifier<Student> {
	@override
	Future<Iterable<Student>> get entities => Cloud.students;
}

final studentsNotifierProvider = StateNotifierProvider<StudentsNotifier, Iterable<Student>?>((ref) {
	return StudentsNotifier();
});


class GroupSection extends EntitiesSection<Student> {
	static const name = "group";
	static const icon = Icons.people;

	@override
	String get sectionName => name;
	@override
	IconData get sectionIcon => icon;

	@override
	StateNotifierProvider<StudentsNotifier, Iterable<Student>?> get provider => studentsNotifierProvider;

	@override
	List<Widget> tiles(BuildContext context, Iterable<Student> students) => [
		for (final student in students) EntityTile(
			title: student.nameRepr,
			subtitle: student.role == Role.ordinary ? null : student.role.name,
			pageBuilder: () => StudentPage(student)
		)
	];
}
