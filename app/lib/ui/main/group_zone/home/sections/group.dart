import 'package:flutter/material.dart';

import 'package:podiynyk/storage/cloud.dart' show Cloud;
import 'package:podiynyk/storage/entities/student.dart';

import 'section.dart';
import 'entity_pages/student.dart';


class GroupSectionCloudData extends CloudSectionData {
	final students = Cloud.students;

	@override
	Future<List<Student>> get counted => students;
}


class GroupSection extends CloudSection<GroupSectionCloudData> {
	static const name = "group";
	static const icon = Icons.people;

	GroupSection() : super(GroupSectionCloudData());

	@override
	String get sectionName => name;
	@override
	IconData get sectionIcon => icon;

	@override
	Widget build(BuildContext context) {
		return FutureBuilder<List<Student>>(
			future: data.students,
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
