import 'package:flutter/material.dart';

import 'package:podiynyk/storage/cloud.dart' show Cloud;
import 'package:podiynyk/storage/entities/question.dart';

import 'section.dart';


class QuestionsSectionCloudData extends CloudSectionData {
	final questions = Cloud.questions;

	@override
	Future<List<Question>> get counted => questions;
}


class QuestionsSection extends CloudSection<QuestionsSectionCloudData> {
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
	Widget build(BuildContext context) {
		return FutureBuilder<List<Question>>(
			future: Cloud.questions,
			builder: (context, snapshot) {
				// todo: what is shown while awaiting
				if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: Icon(icon));
				// if (snapshot.hasError) print(snapshot.error);  // todo: consider handling

				return ListView(
					// todo: define the tiles
					children: const []
				);
			}
		);
	}

	// todo: define
	// @override
	// Widget addEntityButton(BuildContext context) => NewEntityButton(
	// 	pageBuilder: (_) => const Scaffold()
	// );
}
