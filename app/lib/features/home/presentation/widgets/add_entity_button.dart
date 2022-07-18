import 'package:flutter/material.dart';

import 'package:podiinyk/core/presentation/open_page.dart';


class AddEntityButton extends StatelessWidget {
	const AddEntityButton({required this.pageBuilder});

	final Widget Function(BuildContext, void Function() close) pageBuilder;

	@override
	Widget build(BuildContext context) {
		return FloatingActionButton(
			onPressed: () => openPage(
				context: context,
				builder: pageBuilder
			),
			child: const Icon(Icons.add)
		);
	}
}
