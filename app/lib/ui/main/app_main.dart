import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:podiynyk/storage/local.dart';

import 'identification.dart';
import 'group_zone/group_zone.dart';


class AppMain extends StatefulWidget {
	const AppMain();

	@override
	_AppMainState createState() => _AppMainState();
}

class _AppMainState extends State<AppMain> {
	@override
	Widget build(BuildContext context) {
		if (Local.userIsIdentified) return const GroupZone();

		return Provider.value(
			value: _endIdentification,
			child: const Identification()
		);
	}

	void _endIdentification() {
		Local.initData();
		setState(() {});
	}
}
