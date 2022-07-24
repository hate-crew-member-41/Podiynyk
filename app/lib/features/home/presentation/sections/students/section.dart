import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../domain/providers/students.dart';
import '../../widgets/home_section_bar.dart';
import '../section.dart';
import 'list.dart';


class StudentsSection extends HomeSection {
	const StudentsSection();

	@override
	final String name = "group";
	@override
	final IconData icon = Icons.people;

	@override
	Widget build(BuildContext context, WidgetRef ref) {
		final students = ref.watch(studentsProvider);

		return Scaffold(
			appBar: HomeSectionBar(
				name: name,
				icon: icon,
				count: students?.length
			),
			body: StudentList(students)
		);
	}
}
