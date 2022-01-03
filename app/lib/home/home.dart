import 'package:flutter/material.dart';

import 'sections/agenda.dart';
import 'sections/events.dart';
import 'sections/group.dart';
import 'sections/messages.dart';
import 'sections/questions.dart';
import 'sections/section.dart';
import 'sections/subjects.dart';
import 'sections/settings.dart';


class Home extends StatefulWidget {
	@override
	State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
	Section _section = const AgendaSection();

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
				title: Text(_section.name),  // todo: make it show the number the section wants to
				leading: Builder(builder: (context) => GestureDetector(
					child: Icon(_section.icon),
					onTap: () => Scaffold.of(context).openDrawer()
				))
			),
			body: _section,
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

	ListTile _drawerTile(Section section) => ListTile(
		title: Text(section.name),
		leading: Icon(section.icon),
		onTap: () {
			setState(() => _section = section);
			Navigator.of(context).pop();
		}
	);
}
