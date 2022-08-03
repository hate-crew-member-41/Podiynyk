import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:podiinyk/core/domain/user/state.dart';
import '../../../domain/entities/student.dart';

import '../../widgets/entity_list.dart';
import '../../widgets/tiles/entity_tile.dart';

import 'page.dart';


class GroupmateList extends ConsumerWidget {
	const GroupmateList(this.students);

	final Iterable<Student>? students;

	@override
	Widget build(BuildContext context, WidgetRef ref) {
		final user = ref.watch(userProvider);

		return EntityList<Student>(
			students?.where((s) => s.id != user.id),
			tile: (student) => EntityTile(
				title: student.fullName,
				pageBuilder: (context) => StudentPage(student)
			)
		);
	}
}
