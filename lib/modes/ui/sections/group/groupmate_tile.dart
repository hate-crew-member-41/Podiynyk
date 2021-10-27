import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
		var providers = [
			Provider<User>.value(value: context.read<User>()),
			Provider<GroupData>.value(value: context.read<GroupData>()),
			Provider<Appearance>.value(value: context.read<Appearance>())
		];

		return OpenContainer(
			tappable: widget.isInteractive,
			transitionDuration: Duration(seconds: 1),
			closedBuilder: (context, _) => MultiProvider(
				// passing the providers because the tile will be built a different route
				providers: providers,
				builder: (context, _) => _tile(context)
			),
			openBuilder: (context, close) => MultiProvider(
				// passing the providers because the page will be built a different route
				providers: providers,
				builder: (context, _) => _page(context, close)
			)
		);
	}

	ListTile _tile(BuildContext context) => ListTile(
		title: Text(widget.name),
		subtitle: _role == Role.leader ? Text("староста") : null,
		tileColor: context.read<Appearance>().studentColor(_role)
	);

	Container _page(BuildContext context, void Function() close) => Container(
		color: context.read<Appearance>().studentColor(_role),
		child: Column(
			mainAxisAlignment: MainAxisAlignment.center,
			children: [
				Text(widget.name),
				SizedBox(height: 100),
				Column(children: _buttons(context, close))
			]
		)
	);

	// tofix: on the screen the widget is only updated after closing
	List<TextButton> _buttons(BuildContext context, void Function() close) => [
		if (_role == Role.ordinary) TextButton(
			child: Text("довірити"),
			onPressed: () {
				context.read<GroupData>().changeRole(widget.name, Role.trusted);
				setState(() { _role = Role.trusted; });
			}
		)
		else TextButton(
			child: Text("зневірити"),
			onPressed: () {
				context.read<GroupData>().changeRole(widget.name, Role.ordinary);
				setState(() { _role = Role.ordinary; });
			}
		),
		TextButton(
			child: Text("зробити старостою"),
			onPressed: () {
				context.read<GroupData>().makeLeader(widget.name);
				context.read<User>().role = Role.trusted;
				close();
			}
		)
	];
}
