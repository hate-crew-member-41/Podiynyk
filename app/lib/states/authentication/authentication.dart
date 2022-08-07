import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:google_sign_in/google_sign_in.dart';

import 'package:podiinyk/main.dart';

import 'package:podiinyk/core/data/user_repository.dart';
import 'package:podiinyk/core/domain/user/state.dart';
import 'package:podiinyk/core/domain/user/user.dart';


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
							// fix: block multiple attempts
							onPressed: () => _signInWithGoogle(ref),
							child: const Text('Google')
						),
						const TextButton(
							onPressed: null,
							child: Text('Apple')
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
		final userRepository = ref.read(userRepositoryProvider);
		final User user;
		final AppState appState;

		if (cred.additionalUserInfo!.isNewUser) {
			user = User(
				id: userId,
				// do: try to infer the actual values
				firstName: account.displayName ?? '',
				lastName: ''
			);
			await userRepository.initAccount(user);

			appState = AppState.identification;
			print('Authentication: new $userId');
		}
		else {
			user = await userRepository.user(id: userId);
			appState = user.groupId != null ? AppState.home : AppState.identification;
			print('Authentication: existing $userId(${user.groupId})');
		}

		ref.read(initialUserProvider.notifier).state = user;
		ref.read(appStateProvider.notifier).state = appState;
	}
}
