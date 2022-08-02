import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:podiinyk/main.dart';

import 'package:podiinyk/core/data/firebase_options.dart';
import 'package:podiinyk/core/data/user_repository.dart';
import 'package:podiinyk/core/domain/user.dart';


class Loading extends ConsumerWidget {
	const Loading();

	@override
	Widget build(BuildContext context, WidgetRef ref) {
		_initApp(ref);

		return const Scaffold(
			body: Center(child: Icon(Icons.access_time))
		);
	}

	Future<void> _initApp(WidgetRef ref) async {
		await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

		final authUser = FirebaseAuth.instance.currentUser;
		final AppState appState;

		if (authUser != null) {
			final user = await ref.watch(userRepositoryProvider).user(authUser.uid);
			ref.read(initialUserProvider.notifier).state = user;
			appState = AppState.home;	
		}
		else {
			appState = AppState.auth;
		}

		ref.read(appStateProvider.notifier).state = appState;
	}
}
