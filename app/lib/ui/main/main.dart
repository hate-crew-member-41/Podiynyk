import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:podiynyk/storage/cloud.dart' show Cloud;
import 'package:podiynyk/storage/local.dart' show Local;

import 'identification.dart';
import 'group_zone/group_zone.dart';


class AppMain extends StatefulWidget {
	const AppMain();

	@override
	_AppMainState createState() => _AppMainState();
}

class _AppMainState extends State<AppMain> {
	@override
	Widget build(BuildContext context) {
		return Local.userIsIdentified ? FutureBuilder<bool>(
			future: Cloud.leaderIsElected,
			builder: (context, snapshot) {
				if (snapshot.connectionState == ConnectionState.waiting) return const Icon(Icons.cloud_download);
				// if (snapshot.hasError) print(snapshot.error);  // todo: consider handling
				return GroupZone(leaderIsElected: snapshot.data!);
			}
		) : Provider.value(
			value: () => setState(() {}),
			child: const Identification()
		);
	}
}
