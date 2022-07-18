import 'package:flutter/material.dart';

import '../../domain/entities/entity.dart';


class EntitiesList<E extends Entity> extends StatelessWidget {
	const EntitiesList(
		this.entities, {
			required this.tile,
			this.actionButton
		});

	final Iterable<E>? entities;
	final Widget Function(E) tile;
	final Widget? actionButton;

	@override
	Widget build(BuildContext context) {
		if (entities == null) return const Center(child: Icon(Icons.access_time));

		return Scaffold(
			body: ListView(children: [
				for (final entity in entities!) tile(entity)
			]),
			floatingActionButton: actionButton,
		);
	}
}
