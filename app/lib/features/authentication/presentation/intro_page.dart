import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'authentication.dart';


class IntroPage extends ConsumerWidget {
	const IntroPage();

	@override
	Widget build(BuildContext context, WidgetRef ref) {
		return GestureDetector(
			onDoubleTap: () => ref.read(authStateProvider.notifier).state = AuthState.signUp,
			child: Scaffold(body: Column(
				mainAxisAlignment: MainAxisAlignment.center,
				crossAxisAlignment: CrossAxisAlignment.start,
				children: const [
					Text("Introduction"),
					Text("Double tap to continue.")
				]
			))
		);
	}
}
