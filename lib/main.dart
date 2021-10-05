import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'database/models/user.dart';
import 'database/models/group.dart';
import 'database/models/appearance.dart';
import 'database/database.dart';

import 'modes/loading/loading.dart';
import 'modes/ui/ui.dart';


class AppModel with ChangeNotifier {
	final database = Database();

	Widget _currentMode = Loading();

	AppModel(BuildContext context) {
		() async {
			await database.open(context);
			if (database.group.id.isSet) await database.group.syncUserRole();
		}();
	}

	Widget get mode => _currentMode;
	set mode(Widget mode) {
		this._currentMode = mode;
		notifyListeners();
	}

	Future<void> endIdentification() async {
		this.mode = UI();
	}
}


class App extends StatelessWidget {
	@override
	Widget build(BuildContext context) {
		return ChangeNotifierProvider<AppModel>(
			create: (context) => AppModel(context),
			child: Consumer<AppModel>(
				builder: (_, app, __) => MaterialApp(
					home: app.mode is Loading ? app.mode : MultiProvider(
						child: app.mode,
						providers: [
							Provider<Database>.value(value: app.database),
							Provider<User>.value(value: app.database.user),
							Provider<Group>.value(value: app.database.group),
							Provider<Appearance>.value(value: app.database.appearance)
						]
					)
				)
			)
		);
	}
}


void main() {
	runApp(App());
}
