import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:podiinyk/core/domain/user.dart';
import 'package:podiinyk/main.dart';

import '../data/repository.dart';


// do: implement signing up with Apple
// think: define AuthenticationPage for SignUpPage, SignInPage
class SignUpPage extends ConsumerWidget {
	const SignUpPage();

	@override
	Widget build(BuildContext context, WidgetRef ref) {
		return Scaffold(body: Column(
			mainAxisAlignment: MainAxisAlignment.center,
			crossAxisAlignment: CrossAxisAlignment.start,
			children: [
				const Text("Sign up"),
				Row(
					mainAxisAlignment: MainAxisAlignment.spaceEvenly,
					children: [
						TextButton(
							child: const Text('Google'),
							onPressed: () => _signUpWithGoogle(ref)
						),
						TextButton(
							child: const Text('Apple'),
							onPressed: () {}
						)
					]
				)
			]
		));
	}

	// think: rename
	Future<void> _signUpWithGoogle(WidgetRef ref) async {
		final account = await GoogleSignIn().signIn();
		if (account == null) return;

		// do: inform about this part of the Future

		final accountAuth = await account.authentication;
		final authCred = GoogleAuthProvider.credential(
			idToken: accountAuth.idToken,
			accessToken: accountAuth.accessToken
		);
		final cred = await FirebaseAuth.instance.signInWithCredential(authCred);

		final user = StudentUser(
			id: cred.user!.uid,
			// do: try to infer the actual values
			name: account.displayName ?? '',
			surname: '',
			// do: remove after EnteringGroup is implemented
			groupId: 'groupId',
			chosenSubjectIds: <String>{}
		);
		await ref.read(authRepositoryProvider).initUser(user);

		ref.read(initialUserProvider.notifier).state = user;
		ref.read(appStateProvider.notifier).state = AppState.home;
	}
}
