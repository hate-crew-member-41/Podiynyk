import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:podiynyk/database/models/appearance.dart';

import 'sections/group/group.dart';
import 'sections/subjects/subjects.dart';
import 'sections/ui_section.dart';


class UIModel with ChangeNotifier {
	UISection _section = SubjectsSection();

	UISection get section => _section;
	set section(UISection section) {
		_section = section;
		notifyListeners();
	}
}


class UI extends StatelessWidget {
	@override
	Widget build(BuildContext context) {
		return ChangeNotifierProvider<UIModel>(
			create: (_) => UIModel(),
			child: Consumer<UIModel>(builder: (context, ui, __) => Scaffold(
				appBar: AppBar(
					backgroundColor: Appearance.appBar,
					title: Text(ui.section.name)
				),
				backgroundColor: Appearance.background,
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
				color: Appearance.contrast
			),
			title: Text(section.name),
			focusColor: Appearance.appBar,
			onTap: () {
				context.read<UIModel>().section = section;
				Navigator.of(context).pop();
			}
		);
	}
}
