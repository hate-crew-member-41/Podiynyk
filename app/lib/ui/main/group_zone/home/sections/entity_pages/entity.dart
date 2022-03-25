import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../home.dart' show sectionProvider;
import '../section.dart' show EntitiesSection;


class EntityPage extends ConsumerWidget {
	const EntityPage({
		required this.children,
		this.actions = const <Widget>[],
		this.sectionShouldRebuild
	});

	final List<Widget> children;
	final List<Widget> actions;
	final bool Function()? sectionShouldRebuild;

	@override
	Widget build(BuildContext context, WidgetRef ref) {
		if (actions.isNotEmpty) return GestureDetector(
			child: _popScopeBuilder(ref),
			onLongPress: () {
				Navigator.of(context).push(MaterialPageRoute(
					builder: (context) => Scaffold(
						body: Center(child: ListView(
							shrinkWrap: true,
							children: actions
						))
					)
				));
			}
		);
		
		return _popScopeBuilder(ref);
	}

	Widget _popScopeBuilder(WidgetRef ref) {
		if (sectionShouldRebuild != null) return WillPopScope(
			child: _builder(),
			onWillPop: () async {
				final changed = sectionShouldRebuild!();
				if (changed) {
					final section = ref.read(sectionProvider) as EntitiesSection;
					ref.read(section.provider.notifier).rebuild();
				}

				return true;
			},
		);

		return _builder();
	}

	Widget _builder() => Scaffold(
		body: Center(child: ListView(
			shrinkWrap: true,
			children: [
				const ListTile(),
				...children,
				const ListTile()
			]
		))
	);
}


class EntityActionButton extends StatelessWidget {
	final String text;
	final void Function() action;

	const EntityActionButton({
		required this.text,
		required this.action
	});

	@override
	Widget build(BuildContext context) {
		return ListTile(
			title: Text(text),
			onTap: () {
				Navigator.of(context).pop();
				action();
			}
		);
	}
}
