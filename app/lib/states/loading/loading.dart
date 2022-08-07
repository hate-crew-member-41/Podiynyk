import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:firebase_core/firebase_core.dart';

import 'package:podiinyk/main.dart';

import 'package:podiinyk/core/data/firebase_options.dart';
import 'package:podiinyk/core/data/user_repository.dart';
import 'package:podiinyk/core/domain/user/state.dart';


class Loading extends ConsumerWidget {
	const Loading();

	@override
	Widget build(BuildContext context, WidgetRef ref) {
		_initApp(ref);

		return const Scaffold(body: Center(child: Icon(Icons.access_time)));
	}

	Future<void> _initApp(WidgetRef ref) async {
		await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
		await FirebaseAuth.instance.signOut();

		final authUser = FirebaseAuth.instance.currentUser;
		final AppState appState;

		if (authUser != null) {
			final user = await ref.watch(userRepositoryProvider).user(id: authUser.uid);
			ref.read(initialUserProvider.notifier).state = user;
			appState = user.groupId != null ? AppState.home : AppState.identification;
		}
		else {
			appState = AppState.auth;
		}

		print('Loading: ${appState.name}');
		ref.read(appStateProvider.notifier).state = appState;
	}
}
