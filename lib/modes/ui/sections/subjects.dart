import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../database/entities/subject.dart';
import '../../../database/entities/role.dart';
import '../../../database/models/user.dart';
import '../../../database/models/group.dart';
import '../section.dart';
import '../dedicated_widget.dart';


class SubjectsSection extends StatelessWidget {
  final name = 'предмети';

	@override
	Widget build(BuildContext context) {
		return FutureBuilder<List<Subject>>(
			future: context.read<Group>().subjects(),
			builder: _sectionBuilder
		);
	}

	Widget _sectionBuilder(BuildContext context, AsyncSnapshot<List<Subject>> snapshot) {
		if (snapshot.connectionState == ConnectionState.waiting) return Center(child: Text('предмети летять із хмари'));

		if (snapshot.hasData) {
			List<Subject> subjects = snapshot.data!;
			bool userIsLeader = context.read<User>().role == Role.leader;

			return ListView(
				children: subjects.map<DedicatedWidget>(
					(subject) => _tile(subject, userIsLeader)
				).toList()
			);
		}

		return Text(snapshot.error!.toString());
	}

	DedicatedWidget _tile(Subject subject, bool userIsLeader) => DedicatedWidget(
		closedBuilder: (_, __) => _closedTile(subject),
		pageHeadBuilder: () => _pageHeadBuilder(subject, userIsLeader),
		pageBodyBuilder: () => _pageBodyBuilder(subject)
	);

	ListTile _closedTile(Subject subject) {
		return ListTile(
			title: Text(subject.label ?? subject.name),
			subtitle: Text('${subject.numEvents} events (${subject.percentage} %)')
		);
	}

	ListTile _pageHeadBuilder(Subject subject, bool userIsLeader) => ListTile(
		title: Text(subject.label ?? subject.name),
		subtitle: Text('${subject.numEvents} events (${subject.percentage} %), ${subject.numEventsSoFar} so far'),
	);

	Column _pageBodyBuilder(Subject subject) => Column(

	);
}
