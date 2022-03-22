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
		_currentEntities = entities;
	}

	late Future<List<E>> _currentEntities;
	Future<List<E>> get currentEntities => _currentEntities;

	Future<List<E>> get entities;

	Future<Iterable<E>> get counted => currentEntities;

	Future<int> get count => counted.then((counted) => counted.length);

	void rebuild() => notifyListeners();

	Future<void> update() async {
		_currentEntities = entities;
		await _currentEntities;
		notifyListeners();
	}
}

abstract class CloudEntitiesSection<D extends CloudEntitiesSectionData<E>, E> extends Section {
	const CloudEntitiesSection();

	D get data;

	@override
	Widget build(BuildContext context) {
		final data = context.watch<CloudEntitiesSectionData>() as D;

		return FutureBuilder<List<E>>(
			future: data.currentEntities,
			builder: (context, snapshot) {
				if (snapshot.connectionState == ConnectionState.waiting) {
					return Center(child: Icon(sectionIcon));
				}
				// if (snapshot.hasError) print(snapshot.error!);  // todo: consider handling

				return ListView(children: tiles(context, snapshot.data!));
			}
		);
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
	final Widget Function(BuildContext) pageBuilder;

	const NewEntityButton({required this.pageBuilder});

	@override
	Widget build(BuildContext context) {
		return FloatingActionButton(
			child: const Icon(Icons.add),
			onPressed: () async {
				final added = await Navigator.of(context).push<bool>(MaterialPageRoute(builder: pageBuilder));
				if (added == true) context.read<CloudEntitiesSectionData>().update();
			}
		);
	}
}
