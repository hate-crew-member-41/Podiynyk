import 'package:flutter/material.dart';

import 'sections/agenda.dart' show AgendaSection;
import 'sections/events.dart';
import 'sections/group.dart';
import 'sections/messages.dart' show MessagesSection;
import 'sections/questions.dart' show QuestionsSection;
import 'sections/section.dart';
import 'sections/subjects.dart' show SubjectsSection;
import 'sections/settings.dart';


class Home extends StatefulWidget {
	const Home();

	@override
	State<Home> createState() => _HomeState();
}

// todo: consider the alternative designs
class _HomeState extends State<Home> {
	Section _section = const AgendaSection();

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(  // todo: make it show the number the section wants to
				title: Text(_section.name),
				leading: Builder(builder: (context) => GestureDetector(
					child: Icon(_section.icon),
					onTap: () => Scaffold.of(context).openDrawer()
				))
			),
			body: _section,
			floatingActionButton: _section is ExtendableListSection ?
				(_section as ExtendableListSection).floatingActionButton(context) : null,
			// floatingActionButton: _floatingActionButton(context),
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
