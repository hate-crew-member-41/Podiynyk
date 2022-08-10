import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:podiinyk/states/home/domain/providers/students.dart';

import '../../../domain/entities/student.dart';
import '../subjects/list.dart';


class StudentPage extends ConsumerWidget {
	const StudentPage(this.student);

	final Student student;

	@override
	Widget build(BuildContext context, WidgetRef ref) {
		final details = ref.watch(studentDetailsFamily(student));
		return Scaffold(body: Center(child: ListView(
			shrinkWrap: true,
			children: [
				Text(student.fullName),
				if (details != null) ...[
					if (details.info != null) Text(details.info!),
					// fix: SubjectList is a ListView and a child of another ListView
					// SubjectList(details.subjects, showNextEvent: false)
				]
			]
		)));
	}
}
