import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animations/animations.dart';

import 'ui_section.dart';
import 'widgets/groupmate_page.dart';

import 'package:podiynyk/database/models/user.dart';
import 'package:podiynyk/database/models/group_data.dart';
import 'package:podiynyk/database/models/appearance.dart';

import 'package:podiynyk/database/entities/role.dart' show Role;
import 'package:podiynyk/database/entities/groupmate.dart' show Groupmate;


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

			return ListView(
				children: snapshot.data!.map<Widget>(
					(groupmate) => _tile(context, groupmate, userIsLeader)
				).toList()
			);
		}

		return Text(snapshot.error!.toString());
	}

	// todo: make the UI respond to the Futures returned by Group.(changeRole, makeLeader)
	Widget _tile(BuildContext context, Groupmate groupmate, bool userIsLeader) {
		var appearance = context.read<Appearance>();

		var title = Text(groupmate.label ?? groupmate.name);

		var tile = ListTile(
			title: title,
			subtitle: groupmate.role == Role.leader ? Text("староста") : null,
			tileColor: appearance.studentColor(groupmate.role)
		);

		return !userIsLeader ? tile : OpenContainer(
			transitionDuration: Duration(seconds: 1),
			closedBuilder: (_, __) => tile,
			openBuilder: (_, close) => MultiProvider(
				// re-providing the models because the page is opened in a separate route
				child: GroupmatePage(groupmate.label ?? groupmate.name, groupmate.role, close),
				providers: [
					Provider<GroupData>.value(value: context.read<GroupData>()),
					Provider<User>.value(value: context.read<User>()),
					Provider<Appearance>.value(value: context.read<Appearance>())
				]
			)
		);
	}
}
