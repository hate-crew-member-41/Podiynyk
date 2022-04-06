import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:podiynyk/main.dart';

import 'package:podiynyk/storage/cloud.dart';
import 'package:podiynyk/storage/local.dart';
import 'package:podiynyk/storage/entities/candidate.dart';

import '../home/home.dart';


class CandidatesPage extends HookConsumerWidget {
	const CandidatesPage();

	@override
	Widget build(BuildContext context, WidgetRef ref) {
		return Scaffold(body: Center(
			child: HookBuilder(builder: (context) {
				final votedFor = useRef<Candidate?>(null);
				final snapshot = useStream(useMemoized(() => _updates(ref)));

				if (snapshot.connectionState == ConnectionState.waiting) {
					return const Text("awaiting");
				}
				// todo: handle the error

				return  ListView(
					shrinkWrap: true,
					children: [
						for (final candidate in snapshot.data!) ListTile(
							title: Text(candidate.name),
							trailing: candidate.confirmationCount == 0 ? null : Text(candidate.confirmationCount.toString()),
							onTap: () => _handleVote(candidate, votedFor)
						)
					]
				);
			})
		));
	}

	Stream<List<Candidate>> _updates(WidgetRef ref) async* {
		await for (final candidates in Cloud.leaderElectionUpdates) {
			if (candidates != null) {
				yield candidates;
			}
			else {
				ref.read(stateProvider.notifier).state = const Home();
			}
		}
	}

	Future<void> _handleVote(Candidate candidate, ObjectRef<Candidate?> votedFor) async {
		if (candidate.id == Local.userId || candidate.id == votedFor.value?.id) return;

		Cloud.confirmCandidate(candidate, previous: votedFor.value);
		votedFor.value = candidate;
	}
}
