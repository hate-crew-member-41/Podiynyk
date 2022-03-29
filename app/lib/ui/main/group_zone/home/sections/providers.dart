import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:podiynyk/storage/cloud.dart';
import 'package:podiynyk/storage/entities/entity.dart';


typedef EntitiesNotifierProvider<E extends Entity> = StateNotifierProvider<EntitiesNotifier<E>, Iterable<E>?>;


class EntitiesNotifier<E extends Entity> extends StateNotifier<Iterable<E>?> {
	EntitiesNotifier(this.entities): super(null) {
		update();
	}

	final Future<Iterable<E>> Function() entities;

	void rebuild() {
		state = [...state!];
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
