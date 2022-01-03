import 'package:flutter/material.dart';

import 'section.dart';


class QuestionsSection extends Section {
	@override
	final String name = "questions";
	@override
	final IconData icon = Icons.question_answer;

	const QuestionsSection();

	@override
	Widget build(BuildContext context) {
		return Center(child: Icon(icon));
	}
}
