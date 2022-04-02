import 'package:flutter/material.dart';

import 'package:podiynyk/storage/local.dart';


class Identification extends StatelessWidget {
	const Identification();

	static bool get isInProcess => Local.groupId == null || Local.userId == null;

	@override
	Widget build(BuildContext context) {
		return const Scaffold(body: Center(
			child: Text('identification')
		));
	}
}
