import 'package:flutter/material.dart';


extension Formatted on int {
	String get twoDigitRepr => toString().padLeft(2, '0');
}

extension EventDate on DateTime {
	String get dateRepr => '${day.twoDigitRepr}.${month.twoDigitRepr}';

	String forEvent() {
		String repr = dateRepr;
		if (hour != 0 || minute != 0) {
			repr += ', ${hour.twoDigitRepr}:${minute.twoDigitRepr}';
		}

		return repr;
	}
}


abstract class Section extends StatelessWidget {
	abstract final String name;
	abstract final IconData icon;

	const Section();
}

// todo: add an empty tile (the floating action button covers the last one)
// todo: display the added entity in the list (it is not rebuilt, but should it be?)
abstract class CloudListSection<E> extends Section {
	const CloudListSection();

	@override
	Widget build(BuildContext context) {
		return FutureBuilder(
			future: entities,
			builder: _builder
		);
	}

	Future<List<E>> get entities;

	Widget _builder(BuildContext context, AsyncSnapshot<List<E>> snapshot) {
		if (snapshot.connectionState == ConnectionState.waiting) return Center(child: Icon(icon));

		// if (snapshot.hasError) print(snapshot.error);  // todo: consider handling

		return ListView(
			children: [for (final entity in snapshot.data!) tile(entity)],
		);
	}

	ListTile tile(E entity);
}

abstract class ExtendableListSection<E> extends CloudListSection<E> {
	const ExtendableListSection();

	Widget addEntityButton(BuildContext context);
}


class AddEntityButton extends StatelessWidget {
	final Widget newEntityPage;

	const AddEntityButton({required this.newEntityPage});

	@override
	Widget build(BuildContext context) {
		return FloatingActionButton(
			child: const Icon(Icons.add),
			onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => newEntityPage))
		);
	}
}


class NewEntityPage extends StatelessWidget {
	final List<Widget> children;
	final void Function(BuildContext context) addEntity;

	const NewEntityPage({
		required this.children,
		required this.addEntity
	});

	@override
	Widget build(BuildContext context) {
		return GestureDetector(
			onDoubleTap: () => addEntity(context),
			child: Scaffold(
				body: Center(child: ListView(
					shrinkWrap: true,
					children: children
				))
			)
		);
	}
}
