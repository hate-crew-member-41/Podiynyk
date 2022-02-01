import 'package:flutter/material.dart';

import 'home.dart';
import 'leader_determination.dart';


class GroupZone extends StatefulWidget {
	final bool leaderIsConfirmed;

	const GroupZone({required this.leaderIsConfirmed});

	@override
	State<GroupZone> createState() => _GroupZoneState();
}

class _GroupZoneState extends State<GroupZone> {
	@override
	Widget build(BuildContext context) {
		return widget.leaderIsConfirmed ? const Home() : const LeaderDetermination();
	}
}
