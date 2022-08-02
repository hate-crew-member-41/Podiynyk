import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';


class EnteringPage extends ConsumerWidget {
	const EnteringPage();

	@override
	Widget build(BuildContext context, WidgetRef ref) {
		return GestureDetector(
			onDoubleTap: () => _handleJoin,
			child: Scaffold(body: Center(child: Text("Entering")))
		);
	}

	void _handleJoin() {

	}
}
