import 'package:flutter/material.dart';

import 'storage/cloud.dart' show Cloud;

import 'widgets/home.dart';
import 'widgets/loading.dart';


void main() {
	runApp(App());
}


class App extends StatelessWidget {
	@override
	Widget build(BuildContext context) {
		return MaterialApp(
			title: 'Podiynyk',
			home: FutureBuilder(
				future: Cloud.init(),
				builder: (context, snapshot) {
					if (snapshot.connectionState == ConnectionState.waiting) return const Loading();
					// if (snapshot.hasError) print(snapshot.error);  // todo: consider handling
					return const Home();
				},
			)
		);
	}
}
