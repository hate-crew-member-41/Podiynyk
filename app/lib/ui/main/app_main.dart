import 'package:flutter/material.dart';

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';

import 'package:podiynyk/storage/local.dart';

import 'identification.dart';
import 'group_zone/group_zone.dart';


class AppMain extends HookWidget {
	const AppMain();

	@override
	Widget build(BuildContext context) {
		final userIsIdentified = useState(Local.userIsIdentified);

		if (Local.userIsIdentified) return const GroupZone();

		return Provider.value(
			value: () => userIsIdentified.value = Local.userIsIdentified,
			child: const Identification()
		);
	}
}
