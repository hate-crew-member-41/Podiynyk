import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../database/entities/role.dart' show Role;
import '../../../database/entities/groupmate.dart' show Groupmate;
import '../../../database/models/user.dart';
import '../../../database/models/group.dart';
import '../../../database/models/appearance.dart';
import '../dedicated_widget.dart';


class GroupSection extends StatelessWidget {
	final name = "група";

	@override
	Widget build(BuildContext context) {
		return FutureBuilder<List<Groupmate>>(
			future: context.read<Group>().groupmates(),
			builder: _sectionBuilder
		);
	}

	Widget _sectionBuilder(BuildContext context, AsyncSnapshot<List<Groupmate>> snapshot) {
		if (snapshot.connectionState == ConnectionState.waiting) return Center(child: Text('спільногрупники летять із хмари'));

		if (snapshot.hasData) {
			bool userIsLeader = context.read<User>().role == Role.leader;
			Color nonOrdinaryColor = context.read<Appearance>().enabled;
			return ListView(
				children: snapshot.data!.map<DedicatedWidget>(
					(groupmate) => _tile(groupmate, userIsLeader, nonOrdinaryColor)
				).toList()
			);
		}

		return Text(snapshot.error!.toString());
	}

	// todo: hide the buttons after any is pressed,
	// make the UI respond to the Futures returned by Group.(changeRole, makeLeader)
	DedicatedWidget _tile(Groupmate groupmate, bool userIsLeader, Color nonOrdinaryColor) => DedicatedWidget(
		closedBuilder: (_, __) => _closedTile(groupmate, nonOrdinaryColor),
		pageHeadBuilder: () => _pageHeadBuilder(groupmate),
		pageBodyBuilder: () => _pageBodyBuilder(userIsLeader, groupmate)
	);

	ListTile _closedTile(Groupmate groupmate, Color nonOrdinaryColor) => ListTile(
		title: Text(groupmate.label ?? groupmate.name),
		subtitle: groupmate.role == Role.leader ? Text("староста") : null,
		tileColor: groupmate.role.index == Role.ordinary.index ? null : nonOrdinaryColor
	);

	Text _pageHeadBuilder(Groupmate groupmate) => Text(groupmate.label ?? groupmate.name);

	Column _pageBodyBuilder(bool userIsLeader, Groupmate groupmate) => Column(
		children: [
			if (userIsLeader) ...[
				if (groupmate.role == Role.ordinary) TextButton(
					child: Text("make trusted"),
					onPressed: () {
						print('"make trusted" has been pressed');
					}
				)
				else TextButton(
					child: Text("make ordinary"),
					onPressed: () {
						print('"make ordinary" has been pressed');
					}
				),
				TextButton(
					child: Text("make the leader"),
					onPressed: () {
						print('"make the leader" has been pressed');
					}
				)
			],
			if (groupmate.label == null) TextButton(
				child: Text("add a label"),
				onPressed: () {
					print('"add a label" has been pressed');
				}
			)
			else ...[
				TextButton(
					child: Text("change the label"),
					onPressed: () {
						print('"change the label" has been pressed');
					}
				),
				TextButton(
					child: Text("remove the label"),
					onPressed: () {
						print('"remove the label" has been pressed');
					}
				)
			]
		]
	);
}
