import 'package:flutter/material.dart';


abstract class EntitiesList<E> extends StatelessWidget {
	const EntitiesList(this.entities);

	final Iterable<E>? entities;

	@override
	Widget build(BuildContext context) {
		if (entities == null) return const Center(child: Icon(Icons.access_time));

		return ListView(children: [
			for (final entity in entities!) tile(entity)
		]);
	}

	Widget tile(E entity);
}
