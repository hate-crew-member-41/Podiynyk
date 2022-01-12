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
	const Home();

	@override
	State<Home> createState() => _HomeState();
}

// todo: consider the entity counts with the icons instead of the floating action buttons
class _HomeState extends State<Home> {
	Section _section = AgendaSection();

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
				automaticallyImplyLeading: false,
				title: Builder(builder: (context) => Row(
					mainAxisAlignment: MainAxisAlignment.spaceBetween,
					children: [
						GestureDetector(
							child: Text(_section.name),
							onTap: () => Scaffold.of(context).openDrawer()
						),
						Row(children: [
							if (_section is CloudListSection) EntityCount(_section as CloudListSection),
							Padding(
								padding: const EdgeInsets.only(left: 8),
								child: Icon(_section.icon)
							)
						])
					]
				))
			),
			body: _section,
			drawer: Drawer(
				child: Column(
					mainAxisAlignment: MainAxisAlignment.center,
					// tofix: the constructors are called not only when the sections are built
					// CloudListSection ones have Firestore reads which come out useless
					// this makes the number of reads around 6 times more than it needs to be
					children: [
						_drawerTile(AgendaSection()),
						_drawerTile(SubjectsSection()),
						_drawerTile(EventsSection()),
						_drawerTile(MessagesSection()),
						_drawerTile(QuestionsSection()),
						_drawerTile(GroupSection()),
						_drawerTile(const SettingsSection())
					]
				)
			),
			drawerEdgeDragWidth: 150,
			floatingActionButton: _section is ExtendableListSection ?
				(_section as ExtendableListSection).addEntityButton(context) : null
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


class EntityCount extends StatefulWidget {
	final CloudListSection _section;

	const EntityCount(this._section);

	@override
	_EntityCountState createState() => _EntityCountState();
}

class _EntityCountState extends State<EntityCount> {
	bool _isActual = false;
	int? _count;

	@override
	void initState() {
		scheduleRebuild();
		super.initState();
	}

	@override
	void didUpdateWidget(covariant EntityCount oldWidget) {
		_isActual = false;
		scheduleRebuild();
		super.didUpdateWidget(oldWidget);
	}

	void scheduleRebuild() => widget._section.futureEntities.then((entities) => setState(() {
		_isActual = true;
		_count = entities.length;
	}));

	@override
	Widget build(BuildContext context) {
		return AnimatedOpacity(
			opacity: _isActual ? 1 : 0,
			duration: const Duration(milliseconds: 200),
			child: Text(_count.toString())
		);
	}
}
