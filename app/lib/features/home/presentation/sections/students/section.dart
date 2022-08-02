import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../domain/providers/students.dart';

import '../../state.dart';
import '../../widgets/bars/section_bar.dart';

import 'list.dart';


// think: exclude the user
class StudentsSection extends ConsumerWidget {
	const StudentsSection();

	@override
	Widget build(BuildContext context, WidgetRef ref) {
		final students = ref.watch(studentsProvider);

		return Scaffold(
			appBar: SectionBar(
				section: Section.students,
				count: students?.length
			),
			body: StudentList(students)
		);
	}
}
