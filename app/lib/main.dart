import 'package:flutter/material.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';


void main() async {
	runApp(const MyApp());
}

class MyApp extends StatelessWidget {
	const MyApp();

	@override
	Widget build(BuildContext context) {
		return MaterialApp(
			title: 'Подійник',
			themeMode: ThemeMode.dark,
			darkTheme: ThemeData(
				colorScheme: const ColorScheme.dark()
			),
		);
	}
}
