import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';

import 'package:podiynyk/storage/appearance.dart';


abstract class Section extends HookWidget {
	const Section();

	/// The static [nameRepr].
	String get sectionName;
	/// The static [icon].
	IconData get sectionIcon;

	Widget? get actionButton => null;
}


abstract class CloudEntitiesSectionData<E> with ChangeNotifier {
	CloudEntitiesSectionData() {
		update();
	}

	List<E>? _entities;
	List<E>? get entities => _entities;

	Iterable<E>? get countedEntities => _entities;

	Future<List<E>> get entitiesFuture;

	void rebuild() => notifyListeners();

	Future<void> update() async {
		_entities = await entitiesFuture;
		notifyListeners();
	}
}

abstract class CloudEntitiesSection<D extends CloudEntitiesSectionData<E>, E> extends Section {
	const CloudEntitiesSection();

	D get data;

	@override
	Widget build(BuildContext context) {
		final data = context.watch<CloudEntitiesSectionData>() as D;
		if (data.entities == null) return Center(child: Icon(sectionIcon));

		return ListView(children: tiles(context, data.entities!));
	}

	List<Widget> tiles(BuildContext context, List<E> entities);
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
				builder: (_) => ChangeNotifierProvider.value(
					value: context.read<CloudEntitiesSectionData>(),
					child: pageBuilder()
				) 
			))
		);
	}
}
