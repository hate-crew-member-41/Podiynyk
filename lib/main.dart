import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:podiynyk/database/models/user.dart';
import 'package:podiynyk/database/models/group_data.dart';
import 'package:podiynyk/database/models/appearance.dart';
import 'package:podiynyk/database/database.dart';

import 'package:podiynyk/modes/loading/loading.dart';
import 'package:podiynyk/modes/ui/ui.dart';


class AppModel with ChangeNotifier {
	final database = Database();

	Widget _currentMode = Loading();

	AppModel(BuildContext context) {
		() async {
			await database.open(context);
			_setInitialMode();
		}();
	}

	void _setInitialMode() {
		if (database.user.groupId != null) mode = UI();
		// todo: add the else block after the identification process is implemented
	}

	Widget get mode => _currentMode;
	set mode(Widget mode) {
		this._currentMode = mode;
		notifyListeners();
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
							Provider<GroupData>.value(value: app.database.groupData),
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
