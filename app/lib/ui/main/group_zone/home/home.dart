import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


import 'sections/agenda.dart';
import 'sections/events.dart';
import 'sections/group.dart';
import 'sections/messages.dart';
import 'sections/questions.dart';
import 'sections/subjects.dart';
import 'sections/settings.dart';


// todo: restrict access to the actions (FAD, entity actions)
class Home extends StatefulWidget {
	const Home();

	@override
	State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
	// todo: change the types
	dynamic _section = const AgendaSection();
	dynamic _sectionData = AgendaData();

	@override
	Widget build(BuildContext context) {
		return Provider.value(
			value: _sectionData,
			builder: (context, _) => Scaffold(
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
								// todo: add entity count
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
						children: [
							SectionTile(
								name: AgendaSection.name,
								icon: AgendaSection.icon,
								setSection: _setSectionFunction(() => const AgendaSection())
							),
							SectionTile(
								name: SubjectsSection.name,
								icon: SubjectsSection.icon,
								setSection: _setSectionFunction(() => const SubjectsSection())
							),
							SectionTile(
								name: EventsSection.name,
								icon: EventsSection.icon,
								setSection: _setSectionFunction(() => const EventsSection())
							),
							const ListTile(),
							SectionTile(
								name: MessagesSection.name,
								icon: MessagesSection.icon,
								setSection: _setSectionFunction(() => const MessagesSection())
							),
							SectionTile(
								name: QuestionsSection.name,
								icon: QuestionsSection.icon,
								setSection: _setSectionFunction(() => const QuestionsSection())
							),
							SectionTile(
								name: GroupSection.name,
								icon: GroupSection.icon,
								setSection: _setSectionFunction(() => const GroupSection())
							),
							const ListTile(),
							SectionTile(
								name: SettingsSection.name,
								icon: SettingsSection.icon,
								setSection: _setSectionFunction(() => const SettingsSection())
							),
						]
					)
				),
				drawerEdgeDragWidth: 150,
				// todo: add floating action button dependant on the _section
			),
		);
	}

	void Function() _setSectionFunction<S>(S Function() sectionBuilder) => () {
		if (_section is! S) setState(() => _section = sectionBuilder());
	};
}


class SectionTile extends StatelessWidget {
	final String name;
	final IconData icon;
	final void Function() setSection;

	const SectionTile({
		required this.name,
		required this.icon,
		required this.setSection
	});

	@override
	Widget build(BuildContext context) {
		return ListTile(
			title: Text(name),
			leading: Icon(icon),
			onTap: () {
				setSection();
				Navigator.of(context).pop();
			}
		);
	}
}


// class EntityCount extends StatefulWidget {
// 	final CloudListSection _section;

// 	const EntityCount(this._section);

// 	@override
// 	_EntityCountState createState() => _EntityCountState();
// }

// class _EntityCountState extends State<EntityCount> {
// 	bool _isActual = false;
// 	int? _count;

// 	@override
// 	void initState() {
// 		scheduleRebuild();
// 		super.initState();
// 	}

// 	@override
// 	void didUpdateWidget(EntityCount oldWidget) {
// 		_isActual = false;
// 		scheduleRebuild();
// 		super.didUpdateWidget(oldWidget);
// 	}

// 	void scheduleRebuild() => widget._section.entityCount.then((count) => setState(() {
// 		_isActual = true;
// 		_count = count;
// 	}));

// 	@override
// 	Widget build(BuildContext context) {
// 		return AnimatedOpacity(
// 			opacity: _isActual ? 1 : 0,
// 			duration: const Duration(milliseconds: 200),
// 			child: Text(_count.toString())
// 		);
// 	}
// }
