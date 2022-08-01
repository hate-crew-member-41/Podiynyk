import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:podiinyk/main.dart';

import 'package:podiinyk/core/data/firebase_options.dart';
import 'package:podiinyk/core/domain/user.dart';

import '../data/repository.dart';


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
		final app = ref.read(appStateProvider.notifier);

		if (authUser != null) {
			final user = await ref.watch(loadingRepositoryProvider).user(authUser.uid);
			ref.read(initialUserProvider.notifier).state = user;
			app.state = AppState.home;	
		}
		else {
			app.state = AppState.auth;
		}
	}
}
