import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:podiynyk/storage/entities/student.dart';

import 'providers.dart' show EntitiesNotifierProvider, studentsNotifierProvider;
import 'section.dart';
import 'entity_pages/student.dart';


class GroupSection extends EntitiesSection<Student> {
	const GroupSection();

	@override
	String get name => "group";
	@override
	IconData get icon => Icons.people;

	@override
	EntitiesNotifierProvider<Student> get provider => studentsNotifierProvider;

	@override
	Widget build(BuildContext context, WidgetRef ref) {
		final students = ref.watch(studentsNotifierProvider);

		if (students == null) return Center(child: Icon(icon));
		// if (snapshot.hasError) print(snapshot.error);  // todo: consider handling

		return ListView(children: [
			for (final student in students) EntityTile(
				title: student.nameRepr,
				subtitle: student.role == Role.ordinary ? null : student.role!.name,
				pageBuilder: () => StudentPage(student)
			)
		]);
	}
}
