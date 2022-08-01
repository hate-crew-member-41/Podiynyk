import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'intro_page.dart';
import 'sign_in_page.dart';
import 'sign_up_page.dart';
import 'welcome_page.dart';


// think: show a page with the inferred name after SignUpPage
enum AuthState {
	welcome,
	intro,
	signUp,
	signIn
}

final authStateProvider = StateProvider<AuthState>((ref) => AuthState.welcome);


class Authentication extends ConsumerWidget {
	const Authentication();

	@override
	Widget build(BuildContext context, WidgetRef ref) {
		final state = ref.watch(authStateProvider);

		switch (state) {
			case AuthState.welcome:
				return const WelcomePage();
			case AuthState.intro:
				return const IntroPage();
			case AuthState.signUp:
				return const SignUpPage();
			case AuthState.signIn:
				return const SignInPage();
		}
	}
}
