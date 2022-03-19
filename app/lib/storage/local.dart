import 'package:hive_flutter/hive_flutter.dart';

import 'cloud.dart' show CloudId;
import 'fields.dart';
import 'entities/entity.dart';


class Local {
	static late final Box<dynamic> _misc;
	static late final Box<Map> _labels;
	static late final Box<List<String>> _entities;

	/// Initializes the storage and makes the data accessible.
	static Future<void> init() async {
		await Hive.initFlutter();
		// | uncomment, hot restart, comment | to make the user unidentified
		// await Hive.deleteBoxFromDisk(DataBox.misc.name);
		await Future.wait([
			Hive.openBox<dynamic>(DataBox.misc.name).then((box) => _misc = box),
			Hive.openBox<Map>(DataBox.labels.name).then((box) => _labels = box),
			Hive.openBox<List<String>>(DataBox.entities.name).then((box) => _entities = box)
		]);
	}

	/// Whether the user has completed the identification step.
	static bool get userIsIdentified => groupId != null;

	/// The id of the user's group.
	static String? get groupId => _misc.get(Field.groupId.name);
	/// Sets the user's [groupId] to the non-null [id] and initializes the data.
	static set groupId(String? id) {
		_misc.put(Field.groupId.name, id!);

		_labels.putAll({
			Field.students.name: <String, String>{},
			Field.subjects.name: <String, String>{},
			Field.subjectInfo.name: <String, String>{},
			Field.events.name: <String, String>{}
		});
		_entities.putAll({
			Field.unfollowedSubjects.name: <String>[],
			Field.hiddenEvents.name: <String>[]
		});
	}

	/// Whether it is known who is the leader. Either `true` ot `null`.
	static bool? get leaderIsElected => _misc.get(Field.leaderIsElected.name);
	/// Sets [leaderIsElected] to the non-`false` value, because `false` can never be guaranteed.
	static set leaderIsElected(bool? isElected) => _misc.put(Field.leaderIsElected.name, true);

	/// Sets [userId].
	static set userId(String id) => _misc.put(Field.userId.name, id);
	/// The user's id in the group.
	static String get userId => _misc.get(Field.userId.name)!;

	/// Sets [userName].
	static set userName(String name) {
		_misc.put(Field.userName.name, name);
		_misc.put(Field.userId.name, name.safeId);
	}
	/// The user's name.
	static String get userName => _misc.get(Field.userName.name)!;

	/// The [collection] entity's label.
	static String? entityLabel(Field collection, String essence) {
		return _labels.get(collection.name)![essence];
	}

	/// Sets the [collection] entity's [label].
	static Future<void> setEntityLabel(Field collection, String essence, String label) async {
		await _labels.put(
			collection.name,
			_labels.get(collection.name)!..[essence] = label
		);
	}

	/// Deletes the [collection] entity's label.
	static Future<void> deleteEntityLabel(Field collection, String essence) async {
		await _labels.put(
			collection.name,
			_labels.get(collection.name)!..remove(essence)
		);
	}

	/// Deletes the [collection] entities that do not exist anymore.
	static Future<void> clearEntityLabels(Field collection, List<Entity> existing) async {
		final existingEssences = {for (final entity in existing) entity.id};
		final cleared  = _labels.get(collection.name)!..removeWhere(
			(essence, _) => !existingEssences.contains(essence)
		);
		await _labels.put(collection.name, cleared);
	}

	/// Whether the [collection] entity has not been stored.
	static bool entityIsStored(Field collection, String essence) {
		return _entities.get(collection.name)!.contains(essence);
	}

	/// Stores the [collection] entity.
	static Future<void> storeEntity(Field collection, String essence) async {
		await _entities.put(
			collection.name,
			_entities.get(collection.name)!..add(essence)
		);
	}

	/// Deletes the [collection] entity.
	static Future<void> deleteEntity(Field collection, String essence) async {
		await _entities.put(
			collection.name,
			_entities.get(collection.name)!..remove(essence)
		);
	}

	/// Deletes the [collection] entities that do not exist anymore.
	static Future<void> clearStoredEntities(Field collection, List<Entity> existing) async {
		final existingEssences = {for (final entity in existing) entity.id};
		final cleared = _entities.get(collection.name)!..removeWhere(
			(essence) => !existingEssences.contains(essence)
		);
		await _entities.put(collection.name, cleared);
	}
}


/// The [Hive] [Box]es that the local data is stored in.
enum DataBox {
	misc,
	labels,
	entities
}
