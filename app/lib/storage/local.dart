import 'package:hive_flutter/hive_flutter.dart';

import 'entities/entity.dart' show StoredEntity;
import 'entities/event.dart' show EventEssence;
import 'entities/message.dart' show MessageEssence;
import 'entities/subject.dart' show SubjectEssence;


class Local {
	/// Initializes [Hive] and makes the local data accessible.
	static Future<void> init() async {
		await Hive.initFlutter();
		// await Future.wait([
		// 	(await Hive.openBox<String>(DataBox.user.name)).deleteFromDisk(),
		// 	(await Hive.openBox<SubjectEssence>(DataBox.unfollowedSubjects.name)).deleteFromDisk(),
		// 	(await Hive.openBox<EventEssence>(DataBox.hiddenEvents.name)).deleteFromDisk(),
		// 	(await Hive.openBox<MessageEssence>(DataBox.hiddenMessages.name)).deleteFromDisk()
		// ]);
		await Future.wait([
			Hive.openBox<String>(DataBox.user.name),
			Hive.openBox<SubjectEssence>(DataBox.unfollowedSubjects.name),
			Hive.openBox<EventEssence>(DataBox.hiddenEvents.name),
			Hive.openBox<MessageEssence>(DataBox.hiddenMessages.name)
		]);
	}

	/// Whether the user has completed the identification proces and the group is known.
	static bool get userIsIdentified => groupId != null;

	/// The id of the user's group.
	static String? get groupId => Hive.box<String>(DataBox.user.name).get(_Field.groupId.name);
	/// Sets the user's [groupId] to be the non-null [id].
	static set groupId(String? id) => Hive.box<String>(DataBox.user.name).put(_Field.groupId.name, id!);

	/// The user's name.
	static String get name => Hive.box<String>(DataBox.user.name).get(_Field.name.name)!;
	/// Sets the user's [name] to be [name].
	static set name(String name) => Hive.box<String>(DataBox.user.name).put(_Field.name.name, name);
	// todo: switch after identification is implemented
	// static String get name => 'Leader Name';

	/// The [E]ssences of the stored [entities].
	static Iterable<E> storedEntities<E>(DataBox entities) => _box<E>(entities).values;

	/// Whether the [entity]'s [E]ssence is stored.
	static bool entityIsStored<E>(DataBox entities, StoredEntity<E> entity) {
		final storedEssences = _box<E>(entities).values;
		return storedEssences.any((storedEssence) => entity.essenceIs(storedEssence));
	}

	/// Stores the [entity].
	static Future<void> addStoredEntity<E>(DataBox entities, StoredEntity<E> entity) async {
		await _box<E>(entities).add(entity.essence);
	}

	/// Deletes the [entity]'s [E]ssence from the [entities] box.
	static Future<void> deleteStoredEntity<E>(DataBox entities, StoredEntity<E> entity) async {
		final box = _box<E>(entities);
		final key = box.toMap().entries.firstWhere((entry) => entity.essenceIs(entry.value)).key;
		await _box<E>(entities).delete(key);
	}

	/// Deletes from the [entities] box the [Essence]s of the [Entity]s that are no more.
	static void clearStoredEntities<Entity extends StoredEntity<Essence>, Essence>(
		DataBox entities,
		List<Entity> existing
	) {
		final box = _box<Essence>(entities);

		for (final entry in box.toMap().entries) {
			if (existing.every((entity) => !entity.essenceIs(entry.value))) {
				box.delete(entry.key);
			}
		}
	}

	/// The [Box] the [entities] are stored in.
	static Box<V> _box<V>(DataBox entities) => Hive.box<V>(entities.name);
}


/// The [Hive] [Box]es the local data is stored in.
enum DataBox {
	user,
	unfollowedSubjects,
	hiddenEvents,
	hiddenMessages
}

/// The [_Field]s used in the [DataBox].
enum _Field {
	groupId,
	name
}
