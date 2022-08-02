import 'package:flutter/material.dart';

import '../../../domain/entities/student.dart';

import '../../widgets/entity_list.dart';
import '../../widgets/tiles/entity_tile.dart';

import 'page.dart';


class StudentList extends StatelessWidget {
	const StudentList(this.students);

	final Iterable<Student>? students;

	@override
	Widget build(BuildContext context) {
		return EntityList<Student>(
			students,
			tile: (student) => EntityTile(
				title: student.fullName,
				pageBuilder: (context) => StudentPage(student)
			)
		);
	}
}
