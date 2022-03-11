import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:podiynyk/storage/appearance.dart';

import 'sections/agenda.dart';
import 'sections/events.dart';
import 'sections/group.dart';
import 'sections/messages.dart';
// import 'sections/questions.dart';
import 'sections/section.dart';
import 'sections/subjects.dart';
import 'sections/settings.dart';


class Home extends StatefulWidget {
	const Home();

	@override
	State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
	Section _section = AgendaSection();

	@override
	Widget build(BuildContext context) {
		return _section is CloudEntitiesSection ? Provider.value(
			value: (_section as CloudEntitiesSection).data,
			builder: (context, _) => _builder(context),
		) : _builder(context);
	}

	Widget _builder(BuildContext context) => Scaffold(
		appBar: AppBar(
			automaticallyImplyLeading: false,
			title: Builder(builder: (context) => Row(
				mainAxisAlignment: MainAxisAlignment.spaceBetween,
				children: [
					GestureDetector(
						child: Text(_section.sectionName),
						onTap: () => Scaffold.of(context).openDrawer()
					),
					Row(children: [
						if (_section is CloudEntitiesSection)
							EntityCount((_section as CloudEntitiesSection).data.count).withPadding,
						Icon(_section.sectionIcon)
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
						setSection: _setSectionFunction(() => AgendaSection())
					),
					SectionTile(
						name: SubjectsSection.name,
						icon: SubjectsSection.icon,
						setSection: _setSectionFunction(() => SubjectsSection())
					),
					SectionTile(
						name: NonSubjectEventsSection.name,
						icon: NonSubjectEventsSection.icon,
						setSection: _setSectionFunction(() => NonSubjectEventsSection())
					),
					const ListTile(),
					SectionTile(
						name: MessagesSection.name,
						icon: MessagesSection.icon,
						setSection: _setSectionFunction(() => MessagesSection())
					),
					// SectionTile(
					// 	name: QuestionsSection.name,
					// 	icon: QuestionsSection.icon,
					// 	setSection: _setSectionFunction(() => QuestionsSection())
					// ),
					SectionTile(
						name: GroupSection.name,
						icon: GroupSection.icon,
						setSection: _setSectionFunction(() => GroupSection())
					),
					const ListTile(),
					SectionTile(
						name: SettingsSection.name,
						icon: SettingsSection.icon,
						setSection: _setSectionFunction(() => const SettingsSection())
					)
				]
			)
		),
		drawerEdgeDragWidth: 150,
		floatingActionButton: _section.actionButton
	);

	void Function() _setSectionFunction<S extends Section>(S Function() sectionBuilder) => () {
		if (_section is! S) setState(() => _section = sectionBuilder());
	};
}


class EntityCount extends StatelessWidget {
	final Future<int> future;

	const EntityCount(this.future);

	@override
	Widget build(BuildContext context) {
		return FutureBuilder(
			future: future,
			builder: (context, snapshot) {
				if (snapshot.connectionState == ConnectionState.waiting) return Container();
				// if (snapshot.hasError) print(snapshot.error);  // todo: consider handling
				return Text(snapshot.data!.toString());
			}
		);
	}
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
			title: Text(name, style: Appearance.contentText),
			leading: Icon(icon, color: Appearance.contentColor),
			onTap: () {
				setSection();
				Navigator.of(context).pop();
			}
		);
	}
}
