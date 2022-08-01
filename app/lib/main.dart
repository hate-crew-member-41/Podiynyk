import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'features/authentication/presentation/authentication.dart';
import 'features/entering_group/entering_group.dart';
import 'features/home/presentation/home.dart';
import 'features/loading/presentation/loading.dart';


void main() async {
	runApp(const ProviderScope(child: App()));
}


enum AppState {
	loading,
	auth,
	enteringGroup,
	home
}

final appStateProvider = StateProvider<AppState>((ref) => AppState.loading);


class App extends StatelessWidget {
	const App();

	@override
	Widget build(BuildContext context) {
		return MaterialApp(
			title: 'Подійник',
			darkTheme: ThemeData(
				useMaterial3: true,
				colorScheme: const ColorScheme.dark(),
				canvasColor: const Color(0xff1a1a1a)
			),
			home: Consumer(builder: (context, ref, _) {
				switch (ref.watch(appStateProvider)) {
					case AppState.loading:
						return const Loading();
					case AppState.auth:
						return const Authentication();
					case AppState.enteringGroup:
						return const EnteringGroup();
					case AppState.home:
						return const Home();
				}
			})
		);
	}
}
