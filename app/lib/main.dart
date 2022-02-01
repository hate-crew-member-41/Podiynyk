import 'package:flutter/material.dart';

import 'storage/cloud.dart' show Cloud;
import 'storage/local.dart' show Local;

import 'widgets/loading.dart';
import 'widgets/app_main.dart';


void main() {
	runApp(App());
}


// todo: sync the role
class App extends StatelessWidget {
	@override
	Widget build(BuildContext context) {
		return MaterialApp(
			theme: ThemeData(primarySwatch: Colors.grey),
			title: 'Podiynyk',
			home: FutureBuilder(
				future: Future.wait([Local.init(), Cloud.init()]),
				builder: (context, snapshot) {
					if (snapshot.connectionState == ConnectionState.waiting) return const Loading();
					// if (snapshot.hasError) print(snapshot.error);  // todo: consider handling
					return const AppMain();
				}
			)
		);
	}
}
