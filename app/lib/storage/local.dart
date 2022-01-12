import 'package:hive_flutter/hive_flutter.dart';

import 'entities/message.dart';


class Local {
	static late final Box<String> _user;
	static late final Box<String> _hiddenMessagesSubjects;

	static Future<void> init() async {
		await Hive.initFlutter();
		_user = await Hive.openBox(DataBox.user.name);
		_hiddenMessagesSubjects = await Hive.openBox(DataBox.entities.name);
	}

	static bool get userIsIdentified => groupId != null;

	// static String get groupId => _user.get(Field.groupId.name);
	// todo: switch after identification is implemented
	static String? get groupId => 'test.group.id';

	// static String get name => _user.get(Field.name.name);
	// todo: switch after identification is implemented
	static String get name => 'Leader Name';

	static Iterable<String> get hiddenMessagesSubjects => _hiddenMessagesSubjects.values;

	static Future<void> addHiddenMessage(String subject) {
		return _hiddenMessagesSubjects.add(subject);
	}

	static void clearHiddenMessages(List<Message> existing) {
		final existingSubjects = existing.map((message) => message.subject);
		
		for (final entry in _hiddenMessagesSubjects.toMap().entries) {
			if (!existingSubjects.contains(entry.value)) {
				_hiddenMessagesSubjects.delete(entry.key);
			}
		}
	}
}


enum DataBox {
	user,
	entities
}

enum Field {
	groupId,
	name
}
