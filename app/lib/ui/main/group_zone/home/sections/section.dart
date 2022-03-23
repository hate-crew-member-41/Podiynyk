import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:podiynyk/storage/appearance.dart';


abstract class Section extends HookWidget {
	const Section();

	/// The static name.
	String get sectionName;
	/// The static icon.
	IconData get sectionIcon;

	Widget? get actionButton => null;
}


// abstract class CloudEntitiesSectionData<E> with ChangeNotifier {
// 	CloudEntitiesSectionData() {
// 		update();
// 	}

// 	List<E>? _entities;
// 	List<E>? get entities => _entities;

// 	Iterable<E>? get countedEntities => _entities;

// 	Future<List<E>> get entitiesFuture;

// 	void rebuild() => notifyListeners();

// 	Future<void> update() async {
// 		_entities = await entitiesFuture;
// 		notifyListeners();
// 	}
// }

abstract class EntitiesSection<E> extends Section {
	const EntitiesSection();

	Future<Iterable<E>> get entities;

	@override
	Widget build(BuildContext context) {
		final snapshot = useFuture(useMemoized(() => entities));

		if (snapshot.connectionState == ConnectionState.waiting) {
			return Center(child: Icon(sectionIcon));
		}
		// if (snapshot.hasError) print(snapshot.error);  // todo: consider handling

		return ListView(children: tiles(context, snapshot.data!));
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
