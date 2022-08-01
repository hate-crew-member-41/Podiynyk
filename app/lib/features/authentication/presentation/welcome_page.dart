import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'authentication.dart';


// think: define AuthenticationPage (event higher abstraction after EnteringGroup ?)
class WelcomePage extends ConsumerWidget {
	const WelcomePage();

	@override
	Widget build(BuildContext context, WidgetRef ref) {
		return GestureDetector(
			onLongPress: () => _setAuthState(ref, AuthState.intro),
			onDoubleTap: () => _setAuthState(ref, AuthState.signIn),
			child: Scaffold(body: Column(
				mainAxisAlignment: MainAxisAlignment.center,
				crossAxisAlignment: CrossAxisAlignment.start,
				children: const [
					Text("Authentication"),
					Text("Double tap to sign in. Long press to sign up.")
				]
			))
		);
	}

	void _setAuthState(WidgetRef ref, AuthState state) {
		ref.read(authStateProvider.notifier).state = state;
	}
}
