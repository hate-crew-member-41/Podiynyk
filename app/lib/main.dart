import 'package:flutter/material.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'state.dart';

import 'presentation/entering_account/entering_account.dart';
import 'presentation/entering_group/entering_group.dart';
import 'presentation/home/home.dart';
import 'presentation/loading/loading.dart';


void main() async {
	runApp(const ProviderScope(child: App()));
}

class App extends StatelessWidget {
	const App();

	@override
	Widget build(BuildContext context) {
		return MaterialApp(
			title: 'Подійник',
			themeMode: ThemeMode.dark,
			darkTheme: ThemeData(
				colorScheme: const ColorScheme.dark()
			),
			home: Consumer(builder: (context, ref, _) {
				switch (ref.watch(appStateProvider)) {
					case null:
						return const Loading();
					case AppState.enteringAccount:
						return const EnteringAccount();
					case AppState.enteringGroup:
						return const EnteringGroup();
					case AppState.home:
						return const Home();
				}
			})
		);
	}
}
