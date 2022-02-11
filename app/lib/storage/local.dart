import 'package:hive_flutter/hive_flutter.dart';

import 'fields.dart';

import 'entities/entity.dart' show StoredEntity;
import 'entities/event.dart' show EventEssence;
import 'entities/message.dart' show MessageEssence;
import 'entities/subject.dart' show SubjectEssence;


// todo: completely redo storing entities
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
	static String? get groupId => Hive.box<String>(DataBox.user.name).get(Field.groupId.name);
	/// Sets the user's [groupId] to be the non-null [id].
	static set groupId(String? id) => Hive.box<String>(DataBox.user.name).put(Field.groupId.name, id!);

	/// Sets the user's [id].
	static set id(String id) => Hive.box<String>(DataBox.user.name).put(Field.id.name, id);
	/// The user's [id] in the group.
	static String get id => Hive.box<String>(DataBox.user.name).get(Field.id.name)!;

	/// Sets the user's [name].
	static set name(String name) => Hive.box<String>(DataBox.user.name).put(Field.name.name, name);
	/// The user's name.
	static String get name => Hive.box<String>(DataBox.user.name).get(Field.name.name)!;
}


/// The [Hive] [Box]es the local data is stored in.
enum DataBox {
	user,
	unfollowedSubjects,
	hiddenEvents,
	hiddenMessages
}
