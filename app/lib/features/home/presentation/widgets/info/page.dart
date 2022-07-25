import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../domain/entities/info.dart';
import '../../../domain/providers/info.dart';
import '../../../domain/providers/subjects.dart';

import '../bars/action_bar.dart';
import '../bars/action_button.dart';


class InfoPage extends StatelessWidget {
	const InfoPage(this.item);

	final Info item;

	@override
	Widget build(BuildContext context) {
		return Scaffold(body: SafeArea(child: Stack(children: [
			Center(child: ListView(
				shrinkWrap: true,
				// do: take from the theme
				children: [
					const SizedBox(height: 56),
					Text(item.name),
					Text(item.content),
					const SizedBox(height: 56)
				]
			)),
			ActionBar(children: [
				ActionButton(
					icon: Icons.edit,
					action: () {}
				),
				Consumer(builder: (context, ref, _) => ActionButton(
					icon: Icons.delete,
					action: () => _delete(context, ref)
				))
			])
		])));
	}

	// think: confirmation, rename
	void _delete(BuildContext context, WidgetRef ref) {
		if (item.subject != null) {
			ref.read(subjectDetailsProviders(item.subject!).notifier).deleteInfo(item);
		}
		else {
			ref.read(infoProvider.notifier).delete(item);
		}
		Navigator.of(context).pop();
	}
}
