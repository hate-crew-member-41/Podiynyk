import 'package:hive_flutter/hive_flutter.dart';

import 'fields.dart';


// todo: clear stored entities when they are no more
class Local {
	static late final Box<String> _user;
	static late final Box<Map<String, String>> _labels;
	static late final Box<List<String>> _entities;

	/// Initializes the local database and makes the data accessible.
	static Future<void> init() async {
		await Hive.initFlutter();
		// | uncomment, hot restart, comment | to delete all local data
		// await Future.wait([
		// 	(await Hive.openBox<String>(DataBox.user.name)).deleteFromDisk(),
		// 	(await Hive.openBox<List<String>>(DataBox.entities.name)).deleteFromDisk(),
		// ]);
		await Future.wait([
			Hive.openBox<String>(DataBox.user.name).then((box) => _user = box),
			Hive.openBox<Map<String, String>>(DataBox.labels.name).then((box) => _labels = box),
			Hive.openBox<List<String>>(DataBox.entities.name).then((box) => _entities = box)
		]);
	}

	/// Initializes the group-related [Local] data.
	static Future<void> initGroupRelatedData() async {
		await Future.wait([
			_labels.put(Field.events.name, <String, String>{}),
			_entities.put(Field.unfollowedSubjects.name, <String>[]),
			_entities.put(Field.hiddenEvents.name, <String>[])
		]);
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

	/// Sets the [collection] entity's [label].
	static Future<void> setEntityLabel(Field collection, String essence, String label) async {
		final field = collection.name;
		await _labels.put(field, _labels.get(field)!..[essence] = label);
	}

	/// Deletes the [collection] entity's label.
	static Future<void> deleteEntityLabel(Field collection, String essence) async {
		final field = collection.name;
		await _labels.put(field, _labels.get(field)!..remove(essence));
	}

	/// The [collection] entity's label.
	static String? entityLabel(Field collection, String essence) {
		return _labels.get(collection.name)![essence];
	}

	/// Stores the [collection] entity.
	static Future<void> storeEntity(Field collection, String essence) async {
		final field = collection.name;
		await _entities.put(field, _entities.get(field)!..add(essence));
	}

	/// Deletes the [collection] entity.
	static Future<void> deleteEntity(Field collection, String essence) async {
		final field = collection.name;
		await _entities.put(field, _entities.get(field)!..remove(essence));
	}

	/// Whether the [collection] entity has not been stored.
	static bool entityIsUnstored(Field collection, String essence) {
		return !_entities.get(collection.name)!.contains(essence);
	}
}


/// The [Hive] [Box]es that the local data is stored in.
enum DataBox {
	user,
	labels,
	entities
}
