import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:podiynyk/storage/appearance.dart';
import 'package:podiynyk/storage/entities/entity.dart';


abstract class Section extends ConsumerWidget {
	const Section();

	/// The static name.
	String get sectionName;
	/// The static icon.
	IconData get sectionIcon;

	Widget? get actionButton => null;
}


abstract class EntitiesNotifier<E extends Entity> extends StateNotifier<Iterable<E>?> {
	EntitiesNotifier(): super(null) {
		update();
	}

	Future<Iterable<E>> get entities;

	Iterable<E>? get counted => state;

	Future<void> update() async {
		state = await entities;
	}
}


abstract class EntitiesSection<E extends Entity> extends Section {
	const EntitiesSection();

	StateNotifierProvider<EntitiesNotifier<E>, Iterable<E>?> get provider;

	@override
	Widget build(BuildContext context, WidgetRef ref) {
		final entities = ref.watch(provider);

		if (entities == null) return Center(child: Icon(sectionIcon));
		// if (snapshot.hasError) print(snapshot.error);  // todo: consider handling

		return ListView(children: tiles(context, entities));
	}

	List<Widget> tiles(BuildContext context, Iterable<E> entities);
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
