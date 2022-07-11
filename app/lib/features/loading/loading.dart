import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:podiinyk/state.dart';
import 'package:podiinyk/core/data/firebase_options.dart';


class Loading extends ConsumerWidget {
	const Loading();

	@override
	Widget build(BuildContext context, WidgetRef ref) {
		Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)
			.whenComplete(() => ref.read(appStateProvider.notifier).update());

		return const Scaffold(
			body: Center(child: Icon(Icons.access_time))
		);
	}
}
