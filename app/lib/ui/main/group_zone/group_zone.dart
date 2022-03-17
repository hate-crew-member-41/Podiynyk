import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:podiynyk/storage/cloud.dart';
import 'package:podiynyk/storage/local.dart';

import 'leader_election.dart';
import 'home/home.dart';


class GroupZone extends StatefulWidget {
	const GroupZone();

	@override
	State<GroupZone> createState() => _GroupZoneState();
}

class _GroupZoneState extends State<GroupZone> {
	@override
	Widget build(BuildContext context) {
		if (Local.leaderIsElected == true) return const Home();
		
		return FutureBuilder<bool>(
			future: Cloud.leaderIsElected,
			builder: (context, snapshot) {
				if (snapshot.connectionState == ConnectionState.waiting) {
					return const Scaffold(body: Center(child: Text("checking if the leader is known")));
				}
				// if (snapshot.hasError) print(snapshot.error);  // todo: consider handling

				if (snapshot.data!) {
					Local.leaderIsElected = true;
					return const Home();
				}

				return Provider.value(
					value: () => setState(() {}),
					child: const LeaderElection()
				);
			}
		);
	}
}
