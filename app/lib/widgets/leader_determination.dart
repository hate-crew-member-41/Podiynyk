import 'package:flutter/material.dart';

import 'package:podiynyk/storage/cloud.dart' show Cloud;
import 'package:podiynyk/storage/local.dart' show Local;
import 'package:podiynyk/storage/entities/student.dart';


class LeaderElection extends StatefulWidget {
	final void Function() after;

	const LeaderElection({required this.after});

	@override
	State<LeaderElection> createState() => _LeaderElectionState();
}

class _LeaderElectionState extends State<LeaderElection> {
	static const _intro = "The next thing you will see is the list of groupmates that have made it to this point. "
		"When you see the leader, tap on them. If you are the leader, sit back and let them tap on you.";

	late Widget _content;

	_LeaderElectionState() {
		_content = GestureDetector(
			onDoubleTap: () => setState(() {
				_content = LeaderCandidateList(after: widget.after);
			}),
			child: Scaffold(
				body: Column(
					mainAxisAlignment: MainAxisAlignment.center,
					crossAxisAlignment: CrossAxisAlignment.start,
					children: const [
						Text('Almost there'),
						Text(_intro)
					]
				)
			)
		);
	}

	@override
	Widget build(BuildContext context) {
		return _content;
	}
}


class LeaderCandidateList extends StatefulWidget {
	final void Function() after;

	const LeaderCandidateList({required this.after});

	@override
	_LeaderCandidateListState createState() => _LeaderCandidateListState();
}

class _LeaderCandidateListState extends State<LeaderCandidateList> {
	String? _votedForId;

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			body: Center(child: StreamBuilder<List<Student>>(
				stream: Cloud.leaderElectionUpdates,
				builder: (context, snapshot) {
					if (snapshot.connectionState == ConnectionState.waiting) return const Icon(Icons.cloud_download);
					// if (snapshot.hasError) print(snapshot.error);  // todo: consider handling

					return ListView(
						shrinkWrap: true,
						children: [
							for (final student in snapshot.data!) ListTile(
								title: Text(student.name),
								trailing: student.confirmationCount == 0 ? null : Text("${student.confirmationCount}/3"),  // todo: replace the 3 with the variable to be used
								onTap: student.name == Local.name ? null : () {
									if (student.id == _votedForId) return;

									Cloud.changeLeaderVote(toId: student.id, fromId: _votedForId);
									_votedForId = student.id;
								}
							)
						]
					);
				}
			))
		);
	}
}
