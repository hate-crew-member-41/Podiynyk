import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart' show Firebase;

import 'widgets/home.dart';
import 'widgets/loading.dart';
import 'storage/cloud.dart';


void main() {
	runApp(App());
}


class App extends StatelessWidget {
	@override
	Widget build(BuildContext context) {
		return MaterialApp(
			title: 'Podiynyk',
			home: FutureBuilder(
				future: Firebase.initializeApp().then((_) => Cloud.roles()),
				builder: (context, snapshot) {
					if (snapshot.connectionState == ConnectionState.waiting) return const Loading();
					// todo: think about handling the error
					return const Home();
				},
			)
		);
	}
}
