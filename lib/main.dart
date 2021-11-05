import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:podiynyk/database/models/user.dart';
import 'package:podiynyk/database/database.dart';

import 'package:podiynyk/modes/loading/loading.dart';
import 'package:podiynyk/modes/ui/ui.dart';


class AppModel with ChangeNotifier {
	Widget _currentMode = Loading();

	AppModel(BuildContext context) {
		() async {
			await Database.open(context);
			_setInitialMode();
		}();
	}

	void _setInitialMode() {
		if (User.groupId != null) mode = UI();
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
					home: app.mode
				)
			)
		);
	}
}


void main() {
	runApp(App());
}
