import 'package:flutter/material.dart';

import 'package:podiynyk/storage/cloud.dart' show Cloud;
import 'package:podiynyk/storage/entities/question.dart';


class QuestionsSection extends StatelessWidget {
	static const name = "questions";
	static const icon = Icons.question_answer;

	const QuestionsSection();

	@override
	Widget build(BuildContext context) {
		return FutureBuilder<List<Question>>(
			future: Cloud.questions,
			builder: (context, snapshot) {
				// todo: what is shown while awaiting
				if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: Icon(icon));
				// if (snapshot.hasError) print(snapshot.error);  // todo: consider handling

				return ListView(
					children: const [
						// todo: define the tiles
						// ...[for (final question in snapshot.data!) const ListTile()],
						ListTile()
					]
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
