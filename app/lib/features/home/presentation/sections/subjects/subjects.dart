import 'package:flutter/material.dart';

import '../../section.dart';


class SubjectsSection extends HomeSection {
	const SubjectsSection();

	@override
	final String name = "subjects";
	@override
	final IconData icon = Icons.school;
	@override
	final IconData inactiveIcon = Icons.school_outlined;
}
