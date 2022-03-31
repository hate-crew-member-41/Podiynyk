import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';


class EntityPage extends ConsumerWidget {
	const EntityPage({
		required this.children,
		this.actions = const <Widget>[],
		this.onClose
	});

	final List<Widget> children;
	final List<Widget> actions;
	final void Function()? onClose;

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
		if (onClose != null) return WillPopScope(
			child: _builder(),
			onWillPop: () async {
				onClose!();
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
