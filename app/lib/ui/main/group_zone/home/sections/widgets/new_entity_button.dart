import 'package:flutter/material.dart';


class NewEntityButton extends StatelessWidget {
	const NewEntityButton({required this.pageBuilder});

	final Widget Function() pageBuilder;

	@override
	Widget build(BuildContext context) {
		return FloatingActionButton(
			child: const Icon(Icons.add),
			onPressed: () => Navigator.of(context).push<bool>(MaterialPageRoute(
				builder: (_) => pageBuilder()
			))
		);
	}
}
