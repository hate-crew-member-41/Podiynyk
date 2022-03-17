import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:podiynyk/storage/appearance.dart';
import 'package:podiynyk/storage/cloud.dart';
import 'package:podiynyk/storage/local.dart';
import 'package:podiynyk/storage/entities/student.dart';


class LeaderElection extends StatefulWidget {
	const LeaderElection();

	@override
	State<LeaderElection> createState() => _LeaderElectionState();
}

class _LeaderElectionState extends State<LeaderElection> {
	bool _showIntro = true;

	@override
	Widget build(BuildContext context) {
		return _showIntro ? _Introduction(
			showNextPage: () => setState(() => _showIntro = false)
		) : const _CandidateList();
	}
}


class _Introduction extends StatelessWidget {
	final void Function() showNextPage;

	const _Introduction({required this.showNextPage});

	@override
	Widget build(BuildContext context) {
		return GestureDetector(
			onDoubleTap: showNextPage,
			child: Scaffold(
				body: Column(
					mainAxisAlignment: MainAxisAlignment.center,
					crossAxisAlignment: CrossAxisAlignment.start,
					children: [
						Text('Almost there', style: Appearance.headlineText).withPadding,
						const Text(
							"The next thing you will see is the list of your groupmates that have made it to this point.\n\n"
							"When you see the leader, tap on them. If you are the leader, sit back and let them tap on you."
						).withPadding
					]
				)
			)
		);
	}
}


class _CandidateList extends StatefulWidget {
	const _CandidateList();

	@override
	_CandidateListState createState() => _CandidateListState();
}

class _CandidateListState extends State<_CandidateList> {
	String? _votedForId;

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			body: Center(child: StreamBuilder<List<Student>?>(
				stream: _updates(context),
				builder: (context, snapshot) {
					if (snapshot.connectionState == ConnectionState.waiting) {
						return const Text("awaiting the groupmates");
					}
					// if (snapshot.hasError) print(snapshot.error);  // todo: consider handling

					final students = snapshot.data!;
  
					return ListView(
						shrinkWrap: true,
						children: [
							for (final student in students) ListTile(
								title: Text(student.nameRepr),
								trailing: student.confirmationCount == 0 ?
									null :
									Text(student.confirmationCount.toString()),
								onTap: student.nameRepr == Local.userName ? null : () {
									if (student.id == _votedForId) return;

									student.voteFor(previousId: _votedForId);
									_votedForId = student.id;
								}
							)
						]
					);
				}
			))
		);
	}

	Stream<List<Student>> _updates(BuildContext context) async* {
		await for (final students in Cloud.leaderElectionUpdates) {
			if (students != null) {
				yield students;
			}
			else {
				Local.leaderIsElected = true;
				context.read<void Function()>()();
			}
		}
	}
}
