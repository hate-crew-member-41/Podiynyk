import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'ui_section.dart';
import 'widgets/dedicated_widget.dart';

import '../../../database/models/user.dart';
import '../../../database/models/group_data.dart';
import '../../../database/models/appearance.dart';

import '../../../database/entities/role.dart' show Role;
import '../../../database/entities/groupmate.dart' show Groupmate;


class GroupSection extends UISection {
	@override
	final name = "група";

	@override
	Widget build(BuildContext context) {
		return FutureBuilder<List<Groupmate>>(
			future: context.read<GroupData>().groupmates(),
			builder: _sectionBuilder
		);
	}

	Widget _sectionBuilder(BuildContext context, AsyncSnapshot<List<Groupmate>> snapshot) {
		if (snapshot.connectionState == ConnectionState.waiting) return Center(child: Text('летять із хмари'));

		if (snapshot.hasData) {
			bool userIsLeader = context.read<User>().role == Role.leader;
			Color nonOrdinaryStudentColor = context.read<Appearance>().enabled;

			return ListView(
				children: snapshot.data!.map<Widget>(
					(groupmate) => _tile(groupmate, userIsLeader, nonOrdinaryStudentColor)
				).toList()
			);
		}

		return Text(snapshot.error!.toString());
	}

	// todo: hide the buttons after any is pressed,
	// make the UI respond to the Futures returned by Group.(changeRole, makeLeader)
	Widget _tile(Groupmate groupmate, bool userIsLeader, Color nonOrdinaryStudentColor) {
		var title = Text(groupmate.label ?? groupmate.name);

		var tile = ListTile(
			title: title,
			subtitle: groupmate.role == Role.leader ? Text("староста") : null,
			tileColor: groupmate.role.index == Role.ordinary.index ? null : nonOrdinaryStudentColor
		);

		return userIsLeader ? tile : DedicatedWidget(
			closedBuilder: (_, __) => tile,
			pageHeadBuilder: () => title,
			pageBodyBuilder: () => Column(children: _roleButtons(groupmate))
		);
	}

	List<TextButton> _roleButtons(Groupmate groupmate) => [
		if (groupmate.role == Role.ordinary) TextButton(
			child: Text("довірити"),
			onPressed: () {
				print('"${groupmate.name}"."довірити"');
			}
		)
		else TextButton(
			child: Text("зневірити"),
			onPressed: () {
				print('"${groupmate.name}"."зневірити"');
			}
		),
		TextButton(
			child: Text("зробити старостою"),
			onPressed: () {
				print('"${groupmate.name}"."зробити старостою"');
			}
		)
	];
}
