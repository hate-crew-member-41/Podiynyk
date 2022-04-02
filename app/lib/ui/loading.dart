import 'package:flutter/material.dart';

import 'package:podiynyk/storage/appearance.dart';


class Loading extends StatelessWidget {
	const Loading();

	@override
	Widget build(BuildContext context) {
		return Scaffold(body: Center(
			child: Text('🌚', style: Appearance.displayText)
		));
	}
}
