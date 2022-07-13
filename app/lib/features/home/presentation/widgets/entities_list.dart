import 'package:flutter/material.dart';

import '../../domain/entities/entity.dart';


class EntitiesList<E extends Entity> extends StatelessWidget {
	const EntitiesList(this.entities, {required this.tile});

	final Iterable<E>? entities;
	final Widget Function(E) tile;

	@override
	Widget build(BuildContext context) {
		if (entities == null) return const Center(child: Icon(Icons.access_time));

		return ListView(children: [
			for (final entity in entities!) tile(entity)
		]);
	}
}
