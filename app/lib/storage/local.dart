import 'package:hive_flutter/hive_flutter.dart';

import 'entities/entity.dart' show StoredEntity;
import 'entities/event.dart' show EventEssence;
import 'entities/message.dart' show MessageEssence;
import 'entities/subject.dart' show SubjectEssence;


class Local {
	/// Initializes [Hive] and makes the local data accessible.
	static Future<void> init() async {
		await Hive.initFlutter();
		await Future.wait([
			Hive.openBox<String>(StoredEntities.user.name),
			Hive.openBox<SubjectEssence>(StoredEntities.unfollowedSubjects.name),
			Hive.openBox<EventEssence>(StoredEntities.hiddenEvents.name),
			Hive.openBox<MessageEssence>(StoredEntities.hiddenMessages.name)
		]);
	}

	/// Whether the user has completed the identification proces and the group is known.
	static bool get userIsIdentified => groupId != null;

	// static String get groupId => Hive.box(DataBox.user.name).get(Field.group.name);
	// todo: switch after identification is implemented
	/// The id of the user's group.
	static String? get groupId => 'test.group.id';

	// static String get name => Hive.box(DataBox.user.name).get(Field.name.name);
	// todo: switch after identification is implemented
	/// The user's name.
	static String get name => 'Leader Name';

	/// The [E]ssences of the stored [entities].
	static Iterable<E> storedEntities<E>(StoredEntities entities) => _box<E>(entities).values;

	/// Whether the [entity]'s [E]ssence is stored.
	static bool entityIsStored<E>(StoredEntities entities, StoredEntity<E> entity) {
		final storedEssences = _box<E>(entities).values;
		return storedEssences.any((storedEssence) => entity.essenceIs(storedEssence));
	}

	/// Adds the [entity]'s [E]ssence to the [entities] box.
	static Future<void> addStoredEntity<E>(StoredEntities entities, StoredEntity<E> entity) async {
		await _box<E>(entities).add(entity.essence);
	}

	/// Deletes the [entity]'s [E]ssence from the [entities] box.
	static Future<void> deleteStoredEntity<E>(StoredEntities entities, StoredEntity<E> entity) async {
		final box = _box<E>(entities);
		final key = box.toMap().entries.firstWhere((entry) => entity.essenceIs(entry.value)).key;
		await _box<E>(entities).delete(key);
	}

	/// Deletes from the [entities] box the [Essence]s of the [Entity]s that are no more.
	static void clearStoredEntities<Entity extends StoredEntity<Essence>, Essence>(
		StoredEntities entities,
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
	static Box<V> _box<V>(StoredEntities entities) => Hive.box<V>(entities.name);
}


/// The [Hive] [Box]es the local data is stored in.
enum StoredEntities {
	user,
	unfollowedSubjects,
	hiddenEvents,
	hiddenMessages
}

/// The [Field]s used in the [StoredEntities].
enum Field {
	groupId,
	name
}
