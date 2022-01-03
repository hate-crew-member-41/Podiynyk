import 'package:flutter/material.dart';

import 'section.dart';


class QuestionsSection extends Section {
	@override
	final String name = "questions";
	@override
	final IconData icon = Icons.question_answer;
	@override
	final bool hasAddAction = true;

	const QuestionsSection();

	@override
	Widget build(BuildContext context) {
		return Center(child: Icon(icon));
	}
}
