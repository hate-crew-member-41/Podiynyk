import 'package:flutter/material.dart';

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';

import 'package:podiynyk/storage/cloud.dart';
import 'package:podiynyk/storage/local.dart';

import 'leader_election.dart';
import 'home/home.dart';


class GroupZone extends HookWidget {
	const GroupZone();

	@override
	Widget build(BuildContext context) {
		final leaderIsElected = useState(Local.leaderIsElected);

		if (Local.leaderIsElected == true) {
			return FutureBuilder(
				future: Cloud.initRole(),
				builder: (context, snapshot) {
					if (snapshot.connectionState == ConnectionState.waiting) {
						return const Scaffold(body: Center(child: Text("syncing the role")));
					}
					// if (snapshot.hasError) print(snapshot.error);  // todo: consider handling

					return const Home();
				}
			);
		}

		return FutureBuilder<bool>(
			future: Cloud.leaderIsElected,
			builder: (context, snapshot) {
				if (snapshot.connectionState == ConnectionState.waiting) {
					return const Scaffold(body: Center(child: Text("checking if the leader is known")));
				}
				// if (snapshot.hasError) print(snapshot.error);  // todo: consider handling

				if (snapshot.data!) return const Home();

				return Provider.value(
					value: () => leaderIsElected.value = Local.leaderIsElected,
					child: const LeaderElection()
				);
			}
		);
	}
}
