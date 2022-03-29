import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:podiynyk/storage/appearance.dart';
import 'package:podiynyk/storage/cloud.dart' show EntityCollectionRefs;
import 'package:podiynyk/storage/entities/entity.dart';


typedef EntitiesNotifierProvider<E extends Entity> = StateNotifierProvider<EntitiesNotifier<E>, Iterable<E>?>;


abstract class Section extends ConsumerWidget {
	const Section();

	String get name;
	IconData get icon;

	Widget? get actionButton => null;
}


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


abstract class EntitiesSection<E extends Entity> extends Section {
	const EntitiesSection();

	StateNotifierProvider<EntitiesNotifier<E>, Iterable<E>?> get provider;

	EntitiesNotifier<E> notifier(WidgetRef ref) => ref.read(provider.notifier);

	Iterable<E>? shownEntities(Iterable<E>? entities) => entities;

	Iterable<E>? countedEntities(WidgetRef ref) => shownEntities(ref.watch(provider));
}


class EntityTile extends StatelessWidget {
	final String title;
	final String? subtitle;
	final String? trailing;
	final Widget Function() pageBuilder;

	const EntityTile({
		required this.title,
		this.subtitle,
		this.trailing,
		required this.pageBuilder
	});

	@override
	Widget build(BuildContext context) {
		return ListTile(
			title: Text(title),
			subtitle: subtitle != null ? Text(subtitle!, style: Appearance.labelText) : null,
			trailing: trailing != null ? Text(trailing!, style: Appearance.titleText) : null,
			onTap: () => Navigator.of(context).push(MaterialPageRoute(
				builder: (_) => pageBuilder()
			))
		);
	}
}


class NewEntityButton extends StatelessWidget {
	final Widget Function() pageBuilder;

	const NewEntityButton({required this.pageBuilder});

	@override
	Widget build(BuildContext context) {
		return FloatingActionButton(
			child: const Icon(Icons.add),
			onPressed: () => Navigator.of(context).push<bool>(MaterialPageRoute(
				builder: (_) => pageBuilder()
			))
		);
	}
}
