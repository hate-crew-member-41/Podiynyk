import 'package:hive_flutter/hive_flutter.dart';

import 'cloud.dart';
import 'fields.dart';
import 'entities/entity.dart';


/// The [Hive] [Box]es that the local data is stored in.
enum DataBox {
	misc,
	labels,
	entities
}


abstract class Local {
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
	// static String? get groupId => _misc.get(Identifier.groupId.name);
	static String? get groupId => 'zc1hMAjhkRSJ7l6lsjCU';
	/// Sets the user's [groupId] and initializes the data.
	static set groupId(String? id) {
		_misc.put(Identifier.groupId.name, id!);

		_labels.putAll({
			Identifier.students.name: <String, String>{},
			Identifier.subjects.name: <String, String>{},
			Identifier.subjectInfo.name: <String, String>{},
			Identifier.events.name: <String, String>{}
		});
		_entities.putAll({
			Identifier.unfollowedSubjects.name: <String>[],
			Identifier.hiddenEvents.name: <String>[]
		});
	}

	// /// Whether it is known who is the leader. Either `true` ot `null`.
	// static bool? get leaderIsElected => _misc.get(Identifier.leaderIsElected.name);
	// /// Sets [leaderIsElected] to the non-`false` value, because `false` can never be guaranteed.
	// static set leaderIsElected(bool? isElected) => _misc.put(Identifier.leaderIsElected.name, true);

	/// Sets [userId].
	static set userId(String id) => _misc.put(Identifier.userId.name, id);
	/// The user's id in the group.
	// static String get userId => _misc.get(Identifier.userId.name)!;
	static String get userId => 'dev';

	/// Sets [userName] and initializes [userId] if needed.
	static set userName(String name) {
		_misc.put(Identifier.userName.name, name);
		if (_misc.get(Identifier.userId.name) == null) _misc.put(Identifier.userId.name, name.safeId);
	}
	/// The user's name.
	// static String get userName => _misc.get(Identifier.userName.name)!;
	static String get userName => '🕵️';

	/// The [entity]'s label.
	static String? entityLabel(Entity entity) {
		return _labels.get(entity.labelCollection!.name)![entity.id];
	}

	/// Stores the [entity]'s label.
	static Future<void> storeEntityLabel(Entity entity) async {
		final collection = entity.labelCollection!.name;
		final modified = _labels.get(collection)!..[entity.id] = entity.label;
		await _labels.put(collection, modified);
	}

	/// Deletes the [entity]'s label.
	static Future<void> deleteEntityLabel(Entity entity) async {
		final collection = entity.labelCollection!.name;
		final modified = _labels.get(collection)!..remove(entity.id);
		await _labels.put(collection, modified);
	}

	/// Deletes the [collection]'s entities that do not exist anymore.
	static Future<void> clearEntityLabels(Iterable<Entity> existing) async {
		if (existing.isEmpty) return;

		final collection = existing.first.labelCollection!.name;
		final existingIds = {for (final entity in existing) entity.id};

		final cleared = _labels.get(collection)!..removeWhere((id, _) => !existingIds.contains(id));
		await _labels.put(collection, cleared);
	}

	/// Whether the [entity] has been stored in the [collection].
	static bool entityIsStored(Identifier collection, Entity entity) {
		return _entities.get(collection.name)!.contains(entity.id);
	}

	/// Stores the [entity] in the [collection].
	static Future<void> storeEntity(Identifier collection, Entity entity) async {
		final modified = _entities.get(collection.name)!..add(entity.id);
		await _entities.put(collection.name, modified);
	}

	/// Deletes the [entity] from the [collection].
	static Future<void> deleteEntity(Identifier collection, Entity entity) async {
		final modified = _entities.get(collection.name)!..remove(entity.id);
		await _entities.put(collection.name, modified);
	}

	/// Deletes the [collection]'s outdated entities.
	static Future<void> deleteOutdatedEntities(Identifier collection, Iterable<Entity> existing) async {
		final existingIds = {for (final entity in existing) entity.id};
		final cleared = _entities.get(collection.name)!..removeWhere((id) => !existingIds.contains(id));
		await _entities.put(collection.name, cleared);
	}
}
