import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:podiynyk/storage/cloud.dart';
import 'package:podiynyk/storage/local.dart';

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
				if (snapshot.connectionState == ConnectionState.waiting) return const Scaffold(body: Icon(Icons.cloud_download));
				// if (snapshot.hasError) print(snapshot.error);  // todo: consider handling
				return GroupZone(leaderIsElected: snapshot.data!);
			}
		) : Provider.value(
			value: _endIdentification,
			child: const Identification()
		);
	}

	void _endIdentification() {
		Local.initGroupRelatedData();
		setState(() {});
	}
}
