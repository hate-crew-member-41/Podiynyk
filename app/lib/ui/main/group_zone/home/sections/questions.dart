import 'package:flutter/material.dart';

import 'package:podiynyk/storage/cloud.dart' show Cloud;
import 'package:podiynyk/storage/entities/question.dart';

import 'section.dart';


class QuestionsSectionCloudData extends CloudEntitiesSectionData<Question> {
	final questions = Cloud.questions;

	@override
	Future<List<Question>> get counted => questions;
}


class QuestionsSection extends CloudEntitiesSection<QuestionsSectionCloudData, Question> {
	static const name = "questions";
	static const icon = Icons.question_answer;

	QuestionsSection() : super(QuestionsSectionCloudData());

	@override
	String get sectionName => name;
	@override
	IconData get sectionIcon => icon;
	// todo: define
	@override
	Widget get actionButton => const Scaffold();

	@override
	Future<List<Question>> get entities => data.questions;

	// todo: define
	@override
	List<Widget> tiles(BuildContext context, List<Question> questions) => [];
}
