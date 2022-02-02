import 'package:flutter/material.dart';

import 'package:podiynyk/storage/cloud.dart' show Cloud;


class LeaderDetermination extends StatefulWidget {
	final void Function() after;

	const LeaderDetermination({required this.after});

	@override
	State<LeaderDetermination> createState() => _LeaderDeterminationState();
}

class _LeaderDeterminationState extends State<LeaderDetermination> {
	static const _intro = "The next thing you will see is the list of groupmates that have made it to this point. "
		"When you see the leader, tap on them. If you are the leader, sit back and let them tap on you.";

	late Widget _content;

	_LeaderDeterminationState() {
		_content = GestureDetector(
			onDoubleTap: () => setState(() {
				_content = LeaderDeterminationStudentList(after: widget.after);
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


class LeaderDeterminationStudentList extends StatefulWidget {
	final void Function() after;

	const LeaderDeterminationStudentList({required this.after});

	@override
	_LeaderDeterminationStudentListState createState() => _LeaderDeterminationStudentListState();
}

class _LeaderDeterminationStudentListState extends State<LeaderDeterminationStudentList> {
	
	@override
	Widget build(BuildContext context) {
		return Scaffold(
			body: Center(child: StreamBuilder<Map<String, int?>>(
				stream: Cloud.confirmationUpdates,
				builder: (context, snapshot) {
					if (snapshot.connectionState == ConnectionState.waiting) return const Icon(Icons.cloud_download);
					// if (snapshot.hasError) print(snapshot.error);  // todo: consider handling
					
					final entries = snapshot.data!.entries.toList()..sort((a, b) => a.key.compareTo(b.key));
					return ListView(
						shrinkWrap: true,
						children: [
							for (final entry in entries) ListTile(
								title: Text(entry.key),
								trailing: entry.value == null ? null : Text("${entry.value}/3")  // todo: replace the 3 with the variable to be used
							)
						]
					);
				}
			))
		);
	}
}
