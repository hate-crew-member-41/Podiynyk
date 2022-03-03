import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'leader_election.dart';
import 'home/home.dart';


class GroupZone extends StatefulWidget {
	final bool leaderIsElected;

	const GroupZone({required this.leaderIsElected});

	@override
	State<GroupZone> createState() => _GroupZoneState();
}

class _GroupZoneState extends State<GroupZone> {
	late bool _leaderIsElected;

	@override
	void initState() {
		super.initState();
		_leaderIsElected = widget.leaderIsElected;
	}

	@override
	Widget build(BuildContext context) {
		return _leaderIsElected ? const Home() : Provider.value(
			value: () => setState(() { _leaderIsElected = true; }),
			child: const LeaderElection()
		);
	}
}
