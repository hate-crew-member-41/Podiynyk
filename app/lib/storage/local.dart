import 'package:hive_flutter/hive_flutter.dart';


class Local {
	static late final Box<String> _user;
	static late final Box<String> _studentLabels;

	static Future<void> init() async {
		await Hive.initFlutter();
		_user = await Hive.openBox(DataBox.user.name);
		_studentLabels = await Hive.openBox(DataBox.studentLabels.name);
	}

	static bool get userIsIdentified => groupId != null;

	// static String get groupId => _user.get(Field.groupId.name);
	// todo: change after identification is implemented
	static String? get groupId => 'test.group.id';

	// static String get name => _user.get(Field.name.name);
	// todo: change after identification is implemented
	static String? get name => 'Test Name 1';

	static Future<void> addStudentLabel(String name, String label) => _studentLabels.put(name, label);

	static Map<String, String> get studentLabels => Map<String, String>.from(_studentLabels.toMap());
}


enum DataBox {
	user,
	studentLabels
}

enum Field {
	groupId,
	name
}
