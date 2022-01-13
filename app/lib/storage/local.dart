import 'package:hive_flutter/hive_flutter.dart';

import 'entities/entity.dart' show StoredEntity;
import 'entities/event.dart' show EventEssence;
import 'entities/message.dart' show MessageEssence;


class Local {
	/// Initializes [Hive] and makes the local data accessible.
	static Future<void> init() async {
		await Hive.initFlutter();
		await Future.wait([
			Hive.openBox<String>(DataBox.user.name),
			Hive.openBox<EventEssence>(DataBox.hiddenEvents.name),
			Hive.openBox<MessageEssence>(DataBox.hiddenMessages.name)
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

	/// The [StoredEntity.essence]s of the [entitie]s the user has hidden.
	static Iterable<E> hiddenEntities<E>(DataBox entities) => Hive.box<E>(entities.name).values;

	/// Remembers the [entity] as hidden by the user.
	static Future<void> addHiddenEntity(DataBox entities, StoredEntity entity) async {
		await Hive.box(entities.name).add(entity.essence);
	}

	/// Deletes from the [entities] box the [Entity]ntities that are no more.
	static void clearHiddenEntities<Entity extends StoredEntity<Essence>, Essence>(DataBox entities, List<Entity> existing) {
		final box = Hive.box<Essence>(entities.name);

		for (final entry in box.toMap().entries) {
			if (existing.every((entity) => !entity.essenceIs(entry.value))) {
				box.delete(entry.key);
			}
		}
	}
}


/// The [Hive] [Box]es the local data is stored in.
enum DataBox {
	user,
	hiddenEvents,
	hiddenMessages
}

/// The [Field]s used in the [DataBox]es.
enum Field {
	groupId,
	name
}
