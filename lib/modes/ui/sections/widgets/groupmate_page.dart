import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:podiynyk/database/models/user.dart';
import 'package:podiynyk/database/models/group_data.dart';
import 'package:podiynyk/database/models/appearance.dart';

import 'package:podiynyk/database/entities/role.dart' show Role;


class GroupmatePage extends StatefulWidget {
	final String name;
	final Role role;
	final void Function() close;

	const GroupmatePage(this.name, this.role, this.close);

	@override
	State<GroupmatePage> createState() => _GroupmatePageState();
}

class _GroupmatePageState extends State<GroupmatePage> {
	late Role _role;

	@override
	void initState() {
		super.initState();
		_role = widget.role;
	}

	@override
	Widget build(BuildContext context) {
		return Container(
			color: context.read<Appearance>().studentColor(_role),
			child: Column(
				mainAxisAlignment: MainAxisAlignment.center,
				children: [
					Text(widget.name),
					SizedBox(height: 100),
					Column(children: _buttons(context))
				]
			)
		);
	}

	List<TextButton> _buttons(BuildContext context) => [
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
				widget.close();
			}
		)
	];
}
