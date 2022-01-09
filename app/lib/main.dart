import 'package:flutter/material.dart';

import 'storage/cloud.dart' show Cloud;
import 'storage/local.dart' show Local;

import 'widgets/home.dart' show Home;
import 'widgets/identification.dart';
import 'widgets/loading.dart';


void main() {
	runApp(App());
}


class App extends StatelessWidget {
	@override
	Widget build(BuildContext context) {
		return MaterialApp(
			theme: ThemeData(primarySwatch: Colors.indigo),
			title: 'Podiynyk',
			home: FutureBuilder(
				future: Future.wait([Local.init(), Cloud.init()]),
				builder: (context, snapshot) {
					if (snapshot.connectionState == ConnectionState.waiting) return const Loading();
					// if (snapshot.hasError) print(snapshot.error);  // todo: consider handling
					if (!Local.userIsIdentified) return const Identification();
					return const Home();
				},
			)
		);
	}
}
