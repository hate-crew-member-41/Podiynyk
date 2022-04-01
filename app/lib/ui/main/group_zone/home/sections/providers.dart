import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:podiynyk/storage/cloud.dart';
import 'package:podiynyk/storage/identifiers.dart';
import 'package:podiynyk/storage/entities/entity.dart';
import 'package:podiynyk/storage/entities/subject.dart';
import 'package:podiynyk/storage/entities/subject_info.dart';


typedef EntitiesNotifierProvider<E extends Entity> = StateNotifierProvider<EntitiesNotifier<E>, List<E>?>;


class EntitiesNotifier<E extends Entity> extends StateNotifier<List<E>?> {
	EntitiesNotifier(this.entities): super(null) {
		update();
	}

	final Future<List<E>> Function() entities;

	void replace(E entity, E modified, {bool preserveState = true}) {
		state![state!.indexOf(entity)] = modified;
		if (!preserveState) state = List<E>.from(state!)..sort();
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

	late bool changed;
	late DocumentReference<CloudMap> detailsRef;

	void init(Subject subject) {
		state = subject.info;
		changed = false;
		detailsRef = subject.cloudCollection.detailsRef(subject);
	}

	void update(List<SubjectInfo> info) => state = info;

	Future<void> add(SubjectInfo info) async {
		detailsRef.update({
			'${Identifier.info.name}.${info.id}': info.inCloudFormat
		});

		final snapshot = await detailsRef.get();
		state = [
			for (final entry in snapshot.data()![Identifier.info.name].entries) SubjectInfo.fromCloud(
				id: entry.key,
				object: entry.value
			)
		]..sort();
		changed = true;
	}

	void replace(SubjectInfo info, SubjectInfo modified, {bool preserveState = true}) {
		state![state!.indexOf(info)] = modified;
		if (!preserveState) state = List<SubjectInfo>.from(state!)..sort();
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

final subjectInfoProvider = StateNotifierProvider<SubjectInfoNotifier, List<SubjectInfo>?>(
	(ref) => SubjectInfoNotifier()
);
