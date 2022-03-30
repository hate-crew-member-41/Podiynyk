import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:podiynyk/storage/cloud.dart';
import 'package:podiynyk/storage/entities/entity.dart';


typedef EntitiesNotifierProvider<E extends Entity> = StateNotifierProvider<EntitiesNotifier<E>, List<E>?>;


class EntitiesNotifier<E extends Entity> extends StateNotifier<List<E>?> {
	EntitiesNotifier(this.entities): super(null) {
		update();
	}

	final Future<List<E>> Function() entities;

	void replace(E entity, E modified, {bool preserveState = false}) {
		final entities = preserveState ? state! : List<E>.from(state!);
		state = entities..[entities.indexOf(entity)] = modified;
	}

	Future<void> update() async => state = await entities();

	Future<void> add(E entity) {
		final collection = entity.cloudCollection!, details = entity.detailsInCloudFormat;

		collection.ref.update({entity.id: entity.inCloudFormat});
		if (details != null) collection.detailsRef(entity).set(details);

		return update();
	}
}

final eventsNotifierProvider = EntitiesNotifierProvider((ref) {
	return EntitiesNotifier(() => Cloud.events);
});

final subjectsNotifierProvider = EntitiesNotifierProvider((ref) {
	return EntitiesNotifier(() => Cloud.subjects);
});

final messagesNotifierProvider = EntitiesNotifierProvider((ref) {
	return EntitiesNotifier(() => Cloud.messages);
});

final studentsNotifierProvider = EntitiesNotifierProvider((ref) {
	return EntitiesNotifier(() => Cloud.students);
});
