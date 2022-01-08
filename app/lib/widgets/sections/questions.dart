import 'package:flutter/material.dart';

import 'package:podiynyk/storage/cloud.dart' show Cloud;
import 'package:podiynyk/storage/entities.dart' show Question;

import 'section.dart';


class QuestionsSection extends ExtendableListSection<Question> {
	@override
	final name = "questions";
	@override
	final icon = Icons.question_answer;

	QuestionsSection() {
		// todo: define
		futureEntities = Cloud.questions();
	}

	// todo: define
	@override
	ListTile tile(BuildContext context, Question entity) {
		throw UnimplementedError();
	}

	// todo: define
	@override
	Widget addEntityButton(BuildContext context) => const AddEntityButton(newEntityPage: Scaffold());
}
