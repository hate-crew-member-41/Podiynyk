import 'package:flutter/material.dart';

import 'storage/appearance.dart';
import 'storage/cloud.dart';
import 'storage/local.dart';

import 'ui/loading.dart';
import 'ui/main/app_main.dart';


void main() {
	runApp(App());
}


class App extends StatelessWidget {
	@override
	Widget build(BuildContext context) {
		return MaterialApp(
			title: 'Podiynyk',
			home: FutureBuilder(
				future: Future.wait([Local.init(), Cloud.init()]),
				builder: (context, snapshot) {
					if (snapshot.connectionState == ConnectionState.waiting) return const Loading();
					// if (snapshot.hasError) print(snapshot.error);  // todo: consider handling
					return const AppMain();
				}
			),
			theme: ThemeData(
				canvasColor: Appearance.mainColor,
				// iconTheme: IconThemeData(color: Appearance.contentColor),
				appBarTheme: AppBarTheme(
					backgroundColor: Appearance.accentColor,
					titleTextStyle: Appearance.contentText,
					iconTheme: IconThemeData(color: Appearance.contentColor)
				),
				textButtonTheme: TextButtonThemeData(style: TextButton.styleFrom(
					textStyle: Appearance.contentText,
					padding: Appearance.padding,
					alignment: Alignment.centerLeft
				)),
				floatingActionButtonTheme: FloatingActionButtonThemeData(
					backgroundColor: Appearance.accentColor,
					foregroundColor: Appearance.contentColor
				)
			)
		);
	}
}
