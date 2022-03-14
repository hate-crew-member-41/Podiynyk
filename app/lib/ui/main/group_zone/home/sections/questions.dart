import 'package:flutter/material.dart';

import 'package:podiynyk/storage/cloud.dart' show Cloud;
import 'package:podiynyk/storage/entities/question.dart';

import 'section.dart';


class QuestionsSectionCloudData extends CloudEntitiesSectionData<Question> {
	@override
	final entities = Cloud.questions;
}


class QuestionsSection extends CloudEntitiesSection<QuestionsSectionCloudData, Question> {
	static const name = "questions";
	static const icon = Icons.question_answer;

	QuestionsSection() : super(QuestionsSectionCloudData());

	@override
	String get sectionName => name;
	@override
	IconData get sectionIcon => icon;
	@override
	Widget get actionButton => Container();

	@override
	List<Widget> tiles(BuildContext context, List<Question> questions) => [];
}
