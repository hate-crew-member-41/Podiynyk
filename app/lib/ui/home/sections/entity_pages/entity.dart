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
		return GestureDetector(
			onLongPress: actions.isNotEmpty ?
				() {
					Navigator.of(context).push(MaterialPageRoute(
						builder: (context) => Scaffold(
							body: Center(child: ListView(
								shrinkWrap: true,
								children: actions
							))
						)
					));
				} :
				null,
			child: WillPopScope(
				onWillPop: onClose != null ?
					() async {
						onClose!();
						return true;
					} :
					null,
				child: Scaffold(
					body: Center(child: ListView(
						shrinkWrap: true,
						children: [
							const ListTile(),
							...children,
							const ListTile()
						]
					))
				),
			)
		);
	}
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
