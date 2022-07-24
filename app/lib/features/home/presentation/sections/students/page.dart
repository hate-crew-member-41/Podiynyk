import 'package:flutter/material.dart';

import '../../../domain/entities/student.dart';


class StudentPage extends StatelessWidget {
	const StudentPage(this.student);

	final Student student;

	@override
	Widget build(BuildContext context) {
		return Scaffold(body: Align(
			alignment: Alignment.centerLeft,
			child: Text(student.fullName)
		));
	}
}
