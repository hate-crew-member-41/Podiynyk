import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:podiynyk/modes/ui/sections/ui_section.dart';
import 'package:podiynyk/modes/ui/sections/group/groupmate_page.dart';

import 'package:podiynyk/database/models/user.dart';
import 'package:podiynyk/database/models/group_data.dart';

import 'package:podiynyk/database/entities/subject.dart';
import 'package:podiynyk/database/entities/role.dart';


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
				children: subjects.map<Widget>(
					(subject) => _tile(subject, userIsLeader)
				).toList()
			);
		}

		return Text(snapshot.error!.toString());
	}

	Widget _tile(Subject subject, bool userIsLeader) => _closedTile(subject);

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
