import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:podiynyk/storage/entities/entity.dart';


class NewEntityPage<E extends Entity> extends ConsumerWidget {
	const NewEntityPage({
		required this.children,
		required this.entityOnAdd,
		required this.add
	});

	final List<Widget> children;
	final E? Function() entityOnAdd;
	final void Function(E) add;

	@override
	Widget build(BuildContext context, WidgetRef ref) {
		return GestureDetector(
			onDoubleTap: () async {
				final entity = entityOnAdd();
				if (entity != null) {
					add(entity);
					Navigator.of(context).pop();
				}
			},
			child: Scaffold(
				body: Center(child: ListView(
					shrinkWrap: true,
					children: children
				))
			)
		);
	}
}
