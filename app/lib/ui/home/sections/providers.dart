import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:podiynyk/storage/cloud.dart';
import 'package:podiynyk/storage/identifier.dart';
import 'package:podiynyk/storage/entities/entity.dart';
import 'package:podiynyk/storage/entities/subject.dart';
import 'package:podiynyk/storage/entities/subject_info.dart';


typedef EntitiesNotifierProvider<E extends Entity> = StateNotifierProvider<EntitiesNotifier<E>, List<E>?>;


class EntitiesNotifier<E extends Entity> extends StateNotifier<List<E>?> {
	EntitiesNotifier(this.entities): super(null) {
		update();
	}

	final Future<List<E>> Function() entities;

	void updateEntity(E updated) {
		final index = state!.indexWhere((entity) => entity.id == updated.id);
		state = List<E>.from(state!..[index] = updated)..sort();
	}

	Future<void> update() async => state = await entities();

	Future<void> add(E entity) async {
		final collection = entity.cloudCollection!, details = entity.detailsInCloudFormat;

		collection.ref.update({entity.id: entity.inCloudFormat});
		if (details != null) collection.detailsRef(entity).set(details);

		await update();
	}
}


class SubjectInfoNotifier extends StateNotifier<List<SubjectInfo>?> {
	SubjectInfoNotifier() : super(null);

	late DocumentReference<CloudMap> detailsRef;
	late bool changed;

	void init(Subject subject) {
		state = subject.info;
		detailsRef = subject.cloudCollection.detailsRef(subject);
		changed = false;
	}

	void update(List<SubjectInfo> info) => state = info;

	Future<void> add(SubjectInfo info) async {
		detailsRef.update({
			'${Identifier.info.name}.${info.id}': info.inCloudFormat
		});
		await _update();
	}

	Future<void> delete(SubjectInfo info) async {
		detailsRef.update({
			'${Identifier.info.name}.${info.id}': FieldValue.delete()
		});
		await _update();
	}

	Future<void> _update() async {
		final snapshot = await detailsRef.get();
		state = [
			for (final entry in snapshot.data()![Identifier.info.name].entries) SubjectInfo.fromCloud(
				id: entry.key,
				object: entry.value
			)
		]..sort();

		changed = true;
	}

	void updateItem(SubjectInfo updated) {
		final index = state!.indexWhere((info) => info.id == updated.id);
		state = List<SubjectInfo>.from(state!..[index] = updated)..sort();
		changed = true;
	}
}


final eventsNotifierProvider = EntitiesNotifierProvider(
	(ref) => EntitiesNotifier(() => Cloud.events)
);
final subjectsNotifierProvider = EntitiesNotifierProvider(
	(ref) => EntitiesNotifier(() => Cloud.subjects)
);
final messagesNotifierProvider = EntitiesNotifierProvider(
	(ref) => EntitiesNotifier(() => Cloud.messages)
);
final studentsNotifierProvider = EntitiesNotifierProvider(
	(ref) => EntitiesNotifier(() => Cloud.students)
);

final subjectInfoNotifierProvider = StateNotifierProvider<SubjectInfoNotifier, List<SubjectInfo>?>(
	(ref) => SubjectInfoNotifier()
);
