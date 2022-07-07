import 'package:hooks_riverpod/hooks_riverpod.dart';


enum AppState {
	enteringAccount,
	enteringGroup,
	home
}

class AppStateNotifier extends StateNotifier<AppState?> {
	AppStateNotifier() : super(null);

	// do: determine the state
	void update() {
		state = AppState.home;
	}
}

final appStateProvider = StateNotifierProvider<AppStateNotifier, AppState?>(
	(ref) => AppStateNotifier()
);
