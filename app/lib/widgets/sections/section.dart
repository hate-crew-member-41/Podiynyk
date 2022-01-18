import 'package:flutter/material.dart';


extension on int {
	/// The 2-digit [String] representation. If less than 10, a leading zero is added.
	String get twoDigitRepr => toString().padLeft(2, '0');
}

extension EntityDate on DateTime {
	/// The representation of the date with 2 digits for each part.
	/// If the date is in a future year, it is also included.
	String get dateRepr {
		String repr = '${day.twoDigitRepr}.${month.twoDigitRepr}';
		if (year != DateTime.now().year) repr = '$repr.${year.twoDigitRepr}';
		return repr;
	}

	/// The representation with the weekday, and the time unless it is midnight.
	String get fullRepr {
		late String repr;
		switch (weekday) {
			case 1: repr = 'Monday'; break;
			case 2: repr = 'Tuesday'; break;
			case 3: repr = 'Wednesday'; break;
			case 4: repr = 'Thursday'; break;
			case 5: repr = 'Friday'; break;
			case 6: repr = 'Saturday'; break;
			case 7: repr = 'Sunday'; break;
		}

		repr = '$repr $dateRepr';
		if (hour != 0 || minute != 0) repr = '$repr, ${hour.twoDigitRepr}:${minute.twoDigitRepr}';

		return repr;
	}
}


abstract class Section extends StatelessWidget {
	abstract final String name;
	abstract final IconData icon;

	const Section();
}


// todo: _futureEntries is mutable
/// A [Section] that displays a list of fetched [E]ntities.
abstract class CloudListSection<E> extends Section {
	Future<List<E>>? _futureEntities;
	Future<List<E>> get futureEntities {
		_futureEntities ??= entitiesFuture;
		return _futureEntities!;
	}

	Future<List<E>> get entitiesFuture;

	Future<int> get entityCount => futureEntities.then((entities) => entities.length);

	@override
	Widget build(BuildContext context) {
		return FutureBuilder(
			future: futureEntities,
			builder: _section
		);
	}

	Widget _section(BuildContext context, AsyncSnapshot<List<E>> snapshot) {
		// todo: what is shown while awaiting
		if (snapshot.connectionState == ConnectionState.waiting) return Center(child: Icon(icon));

		// if (snapshot.hasError) print(snapshot.error);  // todo: consider handling

		// idea: consider an AnimatedOpacity animation with a different delay for each tile
		return ListView(
			children: [
				...tiles(context, snapshot.data!),
				if (this is ExtendableListSection) const ListTile()
			]
		);
	}

	List<Widget> tiles(BuildContext context, List<E> entities) => [
		for (final entity in entities) tile(context, entity)
	];

	Widget tile(BuildContext context, E entity);
}


/// A [CloudListSection] that has a [FloatingActionButton] for extending its list.
abstract class ExtendableListSection<E> extends CloudListSection<E> {
	Widget addEntityButton(BuildContext context);
}


class AddEntityButton extends StatelessWidget {
	final Widget Function(BuildContext) pageBuilder;

	const AddEntityButton({required this.pageBuilder});

	@override
	Widget build(BuildContext context) {
		return FloatingActionButton(
			child: const Icon(Icons.add),
			onPressed: () => Navigator.of(context).push(MaterialPageRoute(
				builder: pageBuilder
			))
		);
	}
}
