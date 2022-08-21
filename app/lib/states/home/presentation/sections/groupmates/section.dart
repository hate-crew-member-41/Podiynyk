import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../domain/providers/students.dart';

import '../../state.dart';
import '../../widgets/bars/section_bar.dart';

import 'list.dart';


class GroupmatesSection extends ConsumerWidget {
	const GroupmatesSection();

	@override
	Widget build(BuildContext context, WidgetRef ref) {
		final students = ref.watch(studentsProvider);

		return Scaffold(
			appBar: SectionBar(
				section: Section.groupmates,
				count: students?.length
			),
			body: GroupmateList(students)
		);
	}
}
