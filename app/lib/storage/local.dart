import 'package:hive_flutter/hive_flutter.dart';

import 'identifiers.dart';
import 'entities/entity.dart';
import 'entities/student.dart' show Role;


/// The [Box]es that the local data is stored in.
enum DataBox {
	misc,
	labels,
	entities
}


abstract class Local {
	/// ```
	/// {
	/// 	groupId?: String,
	/// 	userId?: String,
	/// 	userName?: String,
	/// 	userRole?: int
	/// }
	/// ```
	static late final Box<dynamic> _misc;

	/// ```
	/// {
	/// 	events: { $id: $label, ... },
	/// 	subjects: ...,
	/// 	subjectInfo: ...,
	/// 	students: ...
	/// }
	/// ```
	static late final Box<Map> _labels;

	/// ```
	/// {
	/// 	hiddenEvents: [ $id, ... ],
	/// 	unfollowedSubjects: ...
	/// }
	/// ```
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

	/// The id of the user's group.
	// static String? get groupId => _misc.get(Identifier.groupId.name);
	// static String? get groupId => null;
	static String? get groupId => 'zc1hMAjhkRSJ7l6lsjCU';
	// /// Sets the user's [groupId] and initializes the data.
	// static set groupId(String? id) {
	// 	_misc.put(Identifier.groupId.name, id!);

	// 	_labels.putAll({
	// 		Identifier.events.name: <String, String>{}
	// 		Identifier.subjects.name: <String, String>{},
	// 		Identifier.subjectInfo.name: <String, String>{},
	// 		Identifier.students.name: <String, String>{},
	// 	});
	// 	_entities.putAll({
	// 		Identifier.unfollowedSubjects.name: <String>[],
	// 		Identifier.hiddenEvents.name: <String>[]
	// 	});
	// }

	/// The user's id.
	static String? get userId => 'dev';
	// static String? get userId => _misc.get(Identifier.userId.name);
	// /// Sets [userId].
	// static set userId(String? id) => _misc.put(Identifier.userId.name, id);

	/// The user's name.
	static String? get userName => "💻";
	// static String? get userName => _misc.get(Identifier.userName.name);
	// /// Sets [userName] and initializes [userId] if needed.
	// static set userName(String? name) {
	// 	_misc.put(Identifier.userName.name, name);
	// 	if (_misc.get(Identifier.userId.name) == null) _misc.put(Identifier.userId.name, name!.safeId);
	// }

	/// The user's [Role].
	// static Role? get userRole => null;
	static Role? get userRole => Role.values[_misc.get(Identifier.userRole.name)];
	/// Sets [userRole].
	static set userRole(Role? role) => _misc.put(Identifier.userRole.name, role?.index);

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
