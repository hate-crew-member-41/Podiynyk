import 'package:flutter/material.dart';

import 'package:podiynyk/storage/cloud.dart' show Cloud;
import 'package:podiynyk/storage/entities/question.dart';

import 'section.dart';


class QuestionsSection extends ExtendableListSection<Question> {
	@override
	final name = "questions";
	@override
	final icon = Icons.question_answer;

	@override
	Future<List<Question>> get entitiesFuture => Cloud.questions();

	// todo: define
	@override
	Widget tile(BuildContext context, Question entity) {
		throw UnimplementedError();
	}

	// todo: define
	@override
	Widget addEntityButton(BuildContext context) => const AddEntityButton(newEntityPage: Scaffold());
}
