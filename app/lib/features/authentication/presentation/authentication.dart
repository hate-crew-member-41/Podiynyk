import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:podiinyk/main.dart';
import 'package:podiinyk/core/domain/user.dart';

import '../data/repository.dart';


// do: implement signing up with Apple
// think: show a page with the inferred name after signing up
class Authentication extends ConsumerWidget {
	const Authentication();

	@override
	Widget build(BuildContext context, WidgetRef ref) {
		return Scaffold(body: Column(
			mainAxisAlignment: MainAxisAlignment.center,
			crossAxisAlignment: CrossAxisAlignment.start,
			children: [
				const Text("Authentication"),
				Row(
					mainAxisAlignment: MainAxisAlignment.spaceAround,
					children: [
						TextButton(
							child: const Text('Google'),
							onPressed: () => _signInWithGoogle(ref)
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

	Future<void> _signInWithGoogle(WidgetRef ref) async {
		final account = await GoogleSignIn().signIn();
		if (account == null) return;

		// do: inform the user about this part of the Future

		final accountAuth = await account.authentication;
		final authCred = GoogleAuthProvider.credential(
			idToken: accountAuth.idToken,
			accessToken: accountAuth.accessToken
		);
		final cred = await FirebaseAuth.instance.signInWithCredential(authCred);

		final userId = cred.user!.uid;
		final authRepository = ref.read(authRepositoryProvider);
		final StudentUser user;

		if (cred.additionalUserInfo!.isNewUser) {
			user = StudentUser(
				id: userId,
				// do: try to infer the actual values
				name: account.displayName ?? '',
				surname: '',
				// do: remove after EnteringGroup is implemented
				groupId: 'groupId',
				chosenSubjectIds: <String>{}
			);
			await authRepository.initUser(user);
		}
		else {
			user = await authRepository.user(userId);
		}

		ref.read(initialUserProvider.notifier).state = user;
		ref.read(appStateProvider.notifier).state = AppState.home;
	}
}
