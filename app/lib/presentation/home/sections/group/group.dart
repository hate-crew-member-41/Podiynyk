import 'package:flutter/material.dart';

import '../../section.dart';


class GroupSection extends HomeSection {
	const GroupSection();

	@override
	final String name = "group";
	@override
	final IconData icon = Icons.people;
	@override
	final IconData inactiveIcon = Icons.people_outlined;
}
