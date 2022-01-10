import 'package:flutter/material.dart';


extension on int {
	String get twoDigitRepr => toString().padLeft(2, '0');
}

extension EntityDate on DateTime {
	String get dateRepr {
		String repr = '${day.twoDigitRepr}.${month.twoDigitRepr}';
		if (year != DateTime.now().year) repr += '.${year.twoDigitRepr}';
		return repr;
	}

	String get fullRepr {
		String repr = dateRepr;
		if (hour != 0 || minute != 0) repr += ', ${hour.twoDigitRepr}:${minute.twoDigitRepr}';
		return repr;
	}
}


abstract class Section extends StatelessWidget {
	abstract final String name;
	abstract final IconData icon;

	const Section();
}

abstract class CloudListSection<E> extends Section {
	late final Future<List<E>> futureEntities;

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
				for (final entity in snapshot.data!) tile(context, entity),
				const ListTile()
			],
		);
	}

	ListTile tile(BuildContext context, E entity);
}

abstract class ExtendableListSection<E> extends CloudListSection<E> {
	ExtendableListSection();

	Widget addEntityButton(BuildContext context);
}


class AddEntityButton extends StatelessWidget {
	final Widget newEntityPage;

	const AddEntityButton({required this.newEntityPage});

	@override
	Widget build(BuildContext context) {
		return FloatingActionButton(
			child: const Icon(Icons.add),
			onPressed: () => Navigator.of(context).push(MaterialPageRoute(
				builder: (context) => newEntityPage
			))
		);
	}
}
