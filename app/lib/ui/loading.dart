import 'package:flutter/material.dart';


class Loading extends StatelessWidget {
	const Loading();

	@override
	Widget build(BuildContext context) {
		// idea: use the user's color
		return const Scaffold(
			body: Center(child: Text('waking up'))
		);
	}
}
