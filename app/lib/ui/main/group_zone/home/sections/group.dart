import 'package:flutter/material.dart';

import 'package:podiynyk/storage/cloud.dart' show Cloud;
import 'package:podiynyk/storage/entities/student.dart';

import 'entity_pages/student.dart';


class GroupSection extends StatelessWidget {
	static const name = "group";
	static const icon = Icons.people;

	const GroupSection();

	@override
	Widget build(BuildContext context) {
		return FutureBuilder<List<Student>>(
			future: Cloud.students,
			builder: (context, snapshot) {
				// todo: what is shown while awaiting
				if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: Icon(icon));
				// if (snapshot.hasError) print(snapshot.error);  // todo: consider handling

				return ListView(
					children: [for (final student in snapshot.data!) ListTile(
						title: Text(student.name),
						subtitle: student.role == Role.ordinary ? null : Text(student.role!.name),
						onTap: () => Navigator.of(context).push(MaterialPageRoute(
							builder: (context) => StudentPage(student)
						))
					)]
				);
			}
		);
	}
}
