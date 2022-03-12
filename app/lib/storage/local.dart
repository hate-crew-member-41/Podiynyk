import 'package:hive_flutter/hive_flutter.dart';

import 'fields.dart';
import 'entities/entity.dart';


class Local {
	static late final Box<String> _user;
	static late final Box<Map> _labels;
	static late final Box<List<String>> _entities;

	/// Initializes the [Local] database and makes the data accessible.
	static Future<void> init() async {
		await Hive.initFlutter();
		// | uncomment, hot restart, comment | to delete all local data
		// await Future.wait([
		// 	(await Hive.openBox<String>(DataBox.user.name)).deleteFromDisk(),
		// ]);
		await Future.wait([
			Hive.openBox<String>(DataBox.user.name).then((box) => _user = box),
			Hive.openBox<Map>(DataBox.labels.name).then((box) => _labels = box),
			Hive.openBox<List<String>>(DataBox.entities.name).then((box) => _entities = box)
		]);
	}

	/// Initializes the group-related [Local] data.
	static Future<void> initGroupRelatedData() async {
		await Future.wait([
			_labels.putAll({
				Field.students.name: <String, String>{},
				Field.subjects.name: <String, String>{},
				Field.subjectInfo.name: <String, String>{},
				Field.events.name: <String, String>{}
			}),
			_entities.putAll({
				Field.unfollowedSubjects.name: <String>[],
				Field.hiddenEvents.name: <String>[]
			})
		]);
	}

	/// Whether the user has completed the identification process.
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

	/// The [collection] entity's label.
	static String? entityLabel(Field collection, String essence) {
		// tofix: throws:
		// type '_InternalLinkedHashMap<dynamic, dynamic>' is not a subtype of type 'Map<String, String>?' in type cast
		return _labels.get(collection.name)![essence];
	}

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

	/// Deletes the [collection] entities that do not exist anymore.
	static Future<void> clearEntityLabels(Field collection, List<Entity> existing) async {
		final existingEssences = {for (final entity in existing) entity.id};

		final field = collection.name;
		await _labels.put(field, _labels.get(field)!..removeWhere(
			(essence, _) => !existingEssences.contains(essence)
		));
	}

	/// Whether the [collection] entity has not been stored.
	static bool entityIsStored(Field collection, String essence) {
		return _entities.get(collection.name)!.contains(essence);
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

	/// Deletes the [collection] entities that do not exist anymore.
	static Future<void> clearStoredEntities(Field collection, List<Entity> existing) async {
		final existingEssences = {for (final entity in existing) entity.id};

		final field = collection.name;
		await _entities.put(field, _entities.get(field)!..removeWhere(
			(essence) => !existingEssences.contains(essence)
		));
	}
}


/// The [Hive] [Box]es that the local data is stored in.
enum DataBox {
	user,
	labels,
	entities
}
