import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'intro_page.dart';


final pageProvider = StateProvider<Widget>((ref) {
	return const LeaderElectionIntroPage();
});


class LeaderElection extends ConsumerWidget {
	const LeaderElection();

	@override
	Widget build(BuildContext context, WidgetRef ref) {
		return ref.watch(pageProvider);
	}
}
