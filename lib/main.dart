import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'database/models/user.dart';
import 'database/models/group.dart';
import 'database/models/appearance.dart';
import 'database/database.dart';

import 'modes/loading/loading.dart';
import 'modes/registration/identification.dart';
import 'modes/registration/leader_determination.dart';
import 'modes/ui/ui.dart';


class AppModel with ChangeNotifier {
	final database = Database();

	Widget _currentMode = Loading();
	Widget get mode => _currentMode;
	set mode(Widget mode) {
		this._currentMode = mode;
		notifyListeners();
	}

	AppModel(BuildContext context) {
		() async {
			await database.open(context);

			// todo: remove
			database.group.id.eduId = '0';
			database.group.id.departmentId = '16';
			database.group.name = 'ІВ-92';
			database.user.name = 'Victor Buhaiov';
			await database.group.id.set();

			bool groupIdIsSet = database.group.id.isSet;
			if (groupIdIsSet) await database.group.syncUserRole();

			setInitialMode(groupIdIsSet);
		}();
		// todo: sync _user.role
	}

	Future<void> setInitialMode(bool groupIdIsSet) async {
		// todo: consider LeaderDetermination here and in this.endIdentification
		if (database.group.id.isSet) {

			this.mode = UI();
		}
		else this.mode = Identification(await database.heis());  // todo: await what is actually needed | CUC, consider throw + catch
		
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
						providers: [
							Provider<Database>.value(value: app.database),
							Provider<User>.value(value: app.database.user),
							Provider<Group>.value(value: app.database.group),
							Provider<Appearance>.value(value: app.database.appearance)
						],
						child: app.mode
					)
				)
			)
		);
	}
}


void main() {
	runApp(App());
}
