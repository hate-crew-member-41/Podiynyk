import 'package:flutter/material.dart';
import 'package:animations/animations.dart';

import 'package:podiynyk/database/models/user.dart';
import 'package:podiynyk/database/models/group_data.dart';
import 'package:podiynyk/database/models/appearance.dart';

import 'package:podiynyk/database/entities/role.dart' show Role;


class GroupmateTile extends StatefulWidget {
	final String name;
	final Role initialRole;
	final bool isInteractive;

	const GroupmateTile({
		required this.name,
		required this.initialRole,
		required this.isInteractive
	});

	@override
	State<GroupmateTile> createState() => _GroupmateTileState();
}

class _GroupmateTileState extends State<GroupmateTile> {
	late Role _role;

	@override
	void initState() {
		super.initState();
		_role = widget.initialRole;
	}

	@override
	Widget build(BuildContext context) {
		return OpenContainer(
			tappable: widget.isInteractive,
			transitionDuration: Duration(seconds: 1),
			closedBuilder: (context, open) => _tile(),
			openBuilder: (context, close) => _page(close)
		);
	}

	ListTile _tile() => ListTile(
		title: Text(widget.name),
		subtitle: _role == Role.leader ? Text("староста") : null,
		tileColor: Appearance.studentColor(_role)
	);

	Container _page(void Function() close) => Container(
		color: Appearance.studentColor(_role),
		child: Column(
			mainAxisAlignment: MainAxisAlignment.center,
			children: [
				Text(widget.name),
				SizedBox(height: 100),
				Column(children: _buttons(close))
			]
		)
	);

	// tofix: on the screen the widget is only updated after closing
	List<TextButton> _buttons(void Function() close) => [
		if (_role == Role.ordinary) TextButton(
			child: Text("довірити"),
			onPressed: () {
				GroupData.changeRole(widget.name, Role.trusted);
				setState(() { _role = Role.trusted; });
			}
		)
		else TextButton(
			child: Text("зневірити"),
			onPressed: () {
				GroupData.changeRole(widget.name, Role.ordinary);
				setState(() { _role = Role.ordinary; });
			}
		),
		TextButton(
			child: Text("зробити старостою"),
			onPressed: () {
				GroupData.makeLeader(widget.name);
				User.role = Role.trusted;
				close();
			}
		)
	];
}
