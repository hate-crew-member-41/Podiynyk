import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../database/models/appearance.dart';

import 'sections/ui_section.dart';
import 'sections/subjects.dart';
import 'sections/group.dart';


class UIModel with ChangeNotifier {
	// todo: create an abstract class or interface and make the sections its children
	// change dynamic type to the abstract class or the interface here and UIDrawerTile.build.section
	UISection _section = SubjectsSection();

	UISection get section => _section;

	void show(dynamic section) {
		_section = section;
		notifyListeners();
	}
}


class UI extends StatelessWidget {
	@override
	Widget build(BuildContext context) {
		return ChangeNotifierProvider<UIModel>(
			create: (_) => UIModel(),
			child: Consumer2<Appearance, UIModel>(builder: (context, appearance, ui, __) => Scaffold(
				appBar: AppBar(
					backgroundColor: appearance.appBar,
					title: Text(ui.section.name)
				),
				backgroundColor: appearance.background,
				body: ui.section,
				drawer: Drawer(
					child: Center(
						child: Column(
							mainAxisAlignment: MainAxisAlignment.center,
							children: [
								UIDrawerTile(
									icon: Icons.calendar_today,
									sectionBuilder: () => SubjectsSection()
								),
								ListTile(),
								UIDrawerTile(
									icon: Icons.people,
									sectionBuilder: () => GroupSection()
								),
							]
						)
					)
				)
			))
		);
	}
}


class UIDrawerTile extends StatelessWidget {
	final IconData icon;
	final UISection Function() sectionBuilder;

	const UIDrawerTile({required this.icon, required this.sectionBuilder});

	@override
	Widget build(BuildContext context) {
		UISection section = sectionBuilder();

		return ListTile(
			leading: Icon(
				icon,
				color: context.read<Appearance>().contrast
			),
			title: Text(section.name),
			focusColor: context.read<Appearance>().appBar,
			onTap: () {
				context.read<UIModel>().show(section);
				Navigator.of(context).pop();
			}
		);
	}
}
