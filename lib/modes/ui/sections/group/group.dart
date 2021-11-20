import 'package:flutter/material.dart';

import 'package:podiynyk/database/models/group_data.dart';
import 'package:podiynyk/database/models/user.dart';

import 'package:podiynyk/database/entities/groupmate.dart' show Groupmate;
import 'package:podiynyk/database/entities/role.dart' show Role;

import '../ui_section.dart';
import 'groupmate_tile.dart';


class GroupSection extends UISection {
	@override
	final name = "група";

	@override
	Widget build(BuildContext context) {
		return FutureBuilder<List<Groupmate>>(
			future: GroupData.groupmates(),
			builder: _sectionBuilder
		);
	}

	Widget _sectionBuilder(BuildContext context, AsyncSnapshot<List<Groupmate>> snapshot) {
		if (snapshot.connectionState == ConnectionState.waiting)
		return Center(child: Text('летять із хмари'));

		if (snapshot.hasData)
		return ListView(
			children: snapshot.data!.map<Widget>(
				(groupmate) => GroupmateTile(
					name: groupmate.label ?? groupmate.name,
					initialRole: groupmate.role,
					isInteractive: User.role == Role.leader,
				)
			).toList()
		);

		return Text(snapshot.error!.toString());
	}
}
