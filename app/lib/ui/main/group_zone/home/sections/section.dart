import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:podiynyk/storage/entities/entity.dart';

import 'providers.dart' show EntitiesNotifier;


abstract class Section extends ConsumerWidget {
	const Section();

	String get name;
	IconData get icon;

	Widget? get actionButton => null;
}


abstract class EntitiesSection<E extends Entity> extends Section {
	const EntitiesSection();

	StateNotifierProvider<EntitiesNotifier<E>, List<E>?> get provider;

	EntitiesNotifier<E> notifier(WidgetRef ref) => ref.read(provider.notifier);

	Iterable<E>? shownEntities(List<E>? entities) => entities;

	Iterable<E>? countedEntities(WidgetRef ref) => shownEntities(ref.watch(provider));
}
