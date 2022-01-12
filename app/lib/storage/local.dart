import 'package:hive_flutter/hive_flutter.dart';


class Local {
	static late final Box<String> _user;
	// static late Box

	static Future<void> init() async {
		await Hive.initFlutter();
		_user = await Hive.openBox(DataBox.user.name);
	}

	static bool get userIsIdentified => groupId != null;

	// static String get groupId => _user.get(Field.groupId.name);
	// todo: switch after identification is implemented
	static String? get groupId => 'test.group.id';

	// static String get name => _user.get(Field.name.name);
	// todo: switch after identification is implemented
	static String get name => 'Leader Name';

	// static Future<void> openHiddenMessages() async => await 
}


enum DataBox {
	user
}

enum Field {
	groupId,
	name
}
