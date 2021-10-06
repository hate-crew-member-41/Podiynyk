import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'ui_section.dart';
import 'widgets/dedicated_widget.dart';

import '../../../database/models/user.dart';
import '../../../database/models/group_data.dart';

import '../../../database/entities/subject.dart';
import '../../../database/entities/role.dart';


class SubjectsSection extends UISection {
	@override
	final name = 'предмети';

	@override
	Widget build(BuildContext context) {
		return FutureBuilder<List<Subject>>(
			future: context.read<GroupData>().subjects(),
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

	ListTile _closedTile(Subject subject) => ListTile(
		title: Text(subject.label ?? subject.name),
		subtitle: Text("${subject.eventCount} events")
	);

	ListTile _pageHeadBuilder(Subject subject, bool userIsLeader) => ListTile(
		title: Text(subject.label ?? subject.name),
		subtitle: Text("${subject.eventCount} events, ${subject.totalEventCount} so far"),
	);

	Column _pageBodyBuilder(Subject subject) => Column();
}
