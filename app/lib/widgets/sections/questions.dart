import 'package:flutter/material.dart';

import 'section.dart';


class QuestionsSection extends Section {
	@override
	final name = "questions";
	@override
	final icon = Icons.question_answer;
	@override
	final hasAddAction = true;

	const QuestionsSection();

	@override
	Widget build(BuildContext context) {
		return Center(child: Icon(icon));
	}
}
