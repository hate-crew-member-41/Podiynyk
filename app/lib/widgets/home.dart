import 'package:flutter/material.dart';

import 'package:podiynyk/storage/cloud.dart' show Cloud;
import 'package:podiynyk/storage/entities.dart' show Role, Comparing;

import 'sections/agenda.dart';
import 'sections/events.dart';
import 'sections/group.dart';
import 'sections/messages.dart';
import 'sections/questions.dart';
import 'sections/section.dart';
import 'sections/subjects.dart';
import 'sections/settings.dart';


class Home extends StatefulWidget {
	const Home();

	@override
	State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
	Section _section = const AgendaSection();

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
				// title: Text(),  // todo: make it show the number the section wants to
				leading: Builder(builder: (context) => GestureDetector(
					child: Icon(_section.icon),
					onTap: () => Scaffold.of(context).openDrawer()
				))
			),
			body: _section,
			floatingActionButton: _floatingActionButton(context),
			drawer: Drawer(
				child: Column(
					mainAxisAlignment: MainAxisAlignment.center,
					children: [
						_drawerTile(const AgendaSection()),
						_drawerTile(const SubjectsSection()),
						_drawerTile(const EventsSection()),
						_drawerTile(const MessagesSection()),
						_drawerTile(const QuestionsSection()),
						_drawerTile(const GroupSection()),
						_drawerTile(const SettingsSection())
					]
				)
			)
		);
	}

	Widget? _floatingActionButton(BuildContext context) {
		if (!_section.hasAddAction || Cloud.role < Role.trusted) return null;

		if (_section is! AgendaSection) return FloatingActionButton(
			child: const Icon(Icons.add),
			onPressed: () => _section.addAction(context)
		);

		return const AddEventButton();
	}

	ListTile _drawerTile(Section section) => ListTile(
		title: Text(section.name),
		leading: Icon(section.icon),
		onTap: () {
			setState(() => _section = section);
			Navigator.of(context).pop();
		}
	);
}
