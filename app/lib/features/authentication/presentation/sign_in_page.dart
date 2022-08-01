import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';


class SignInPage extends ConsumerWidget {
	const SignInPage();

	@override
	Widget build(BuildContext context, WidgetRef ref) {
		return GestureDetector(
			onDoubleTap: () {},
			child: Scaffold(body: Column(
				mainAxisAlignment: MainAxisAlignment.center,
				crossAxisAlignment: CrossAxisAlignment.start,
				children: const [
					Text("Sign in")
				]
			))
		);
	}
}
