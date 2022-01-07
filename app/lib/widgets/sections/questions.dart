import 'package:flutter/material.dart';

import 'section.dart';


// todo: specify the type argument
class QuestionsSection extends ExtendableListSection {
	@override
	final name = "questions";
	@override
	final icon = Icons.question_answer;

	const QuestionsSection();

	// todo: define, specify the type parameter
	@override
	Future<List> get entities => (() async => [])();

	// todo: define
	@override
	ListTile tile(entity) {
		throw UnimplementedError();
	}

	// todo: define
	@override
	Widget get newEntityPage => throw UnimplementedError();
}
