import 'package:hive_flutter/hive_flutter.dart';

import 'fields.dart';
import 'entities/subject.dart';


class Local {
	static late final Box<String> _user;
	static late final Box<List<String>> _entities;

	/// Initializes the local database and makes the data accessible.
	static Future<void> init() async {
		await Hive.initFlutter();
		// uncomment + hot restart to delete all local data
		// await Future.wait([
		// 	(await Hive.openBox<String>(DataBox.user.name)).deleteFromDisk(),
		// 	(await Hive.openBox<List<String>>(DataBox.entities.name)).deleteFromDisk(),
		// ]);
		await Future.wait([
			Hive.openBox<String>(DataBox.user.name).then((box) => _user = box),
			Hive.openBox<List<String>>(DataBox.entities.name).then((box) => _entities = box)
		]);
	}

	/// Initializes the group-related local data.
	static Future<void> initGroupRelatedData() async {
		await _entities.put(Field.unfollowedSubjects.name, <String>[]);
	}

	/// Whether the user has completed the identification proces.
	static bool get userIsIdentified => groupId != null;

	/// The id of the user's group.
	static String? get groupId => _user.get(Field.groupId.name);
	/// Sets the user's [groupId] to be the non-null [id].
	static set groupId(String? id) => _user.put(Field.groupId.name, id!);

	/// Sets the user's [id].
	static set id(String id) => _user.put(Field.id.name, id);
	/// The user's [id] in the group.
	static String get id => _user.get(Field.id.name)!;

	/// Sets the user's [name].
	static set name(String name) => _user.put(Field.name.name, name);
	/// The user's name.
	static String get name => _user.get(Field.name.name)!;

	static Future<void> unfollowSubject(Subject subject) async {
		final field = Field.unfollowedSubjects.name;
		final subjects = _entities.get(field)!;
		await _entities.put(field, subjects..add(subject.essence));
	}

	static Future<void> followSubject(Subject subject) async {
		final field = Field.unfollowedSubjects.name;
		await _entities.put(field, _entities.get(field)!..remove(subject.essence));
	}

	// todo: clear unfollowed ones
	static bool subjectIsFollowed(Subject subject) {
		return !_entities.get(Field.unfollowedSubjects.name)!.contains(subject.essence);
	}
}


/// The [Hive] [Box]es that the local data is stored in.
enum DataBox {
	user,
	entities
}
