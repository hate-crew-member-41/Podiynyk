import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';

import 'package:podiynyk/storage/appearance.dart';

import 'sections/agenda.dart';
import 'sections/non_subject_events.dart';
import 'sections/group.dart';
import 'sections/messages.dart';
// import 'sections/questions.dart';
import 'sections/section.dart';
import 'sections/subjects.dart';
// import 'sections/settings.dart';


class Home extends HookWidget {
	const Home();

	@override
	Widget build(BuildContext context) {
		final section = useState<Section>(AgendaSection());

		if (section.value is CloudEntitiesSection) return ChangeNotifierProvider.value(
			value: (section.value as CloudEntitiesSection).data,
			builder: (context, _) => _builder(context, section)
		);

		return _builder(context, section);
	}

	Widget _builder(BuildContext context, ValueNotifier<Section> section) {
		final entityCount = context.watch<CloudEntitiesSectionData>().countedEntities?.length;

		return Scaffold(
			appBar: AppBar(
				automaticallyImplyLeading: false,
				title: Builder(builder: (context) => Row(
					mainAxisAlignment: MainAxisAlignment.spaceBetween,
					children: [
						GestureDetector(
							child: Text(section.value.sectionName),
							onTap: () => Scaffold.of(context).openDrawer()
						),
						Row(children: [
							if (section.value is CloudEntitiesSection) Visibility(
								visible: entityCount != null,
								child: Text(entityCount.toString()).withPadding(),
							),
							Icon(section.value.sectionIcon)
						])
					]
				))
			),
			body: section.value,
			drawer: Drawer(
				child: Column(
					mainAxisAlignment: MainAxisAlignment.center,
					children: [
						SectionTile(
							name: AgendaSection.name,
							icon: AgendaSection.icon,
							setSection: _setSectionFunction(() => AgendaSection(), section)
						),
						SectionTile(
							name: SubjectsSection.name,
							icon: SubjectsSection.icon,
							setSection: _setSectionFunction(() => SubjectsSection(), section)
						),
						SectionTile(
							name: NonSubjectEventsSection.name,
							icon: NonSubjectEventsSection.icon,
							setSection: _setSectionFunction(() => NonSubjectEventsSection(), section)
						),
						const ListTile(),
						SectionTile(
							name: MessagesSection.name,
							icon: MessagesSection.icon,
							setSection: _setSectionFunction(() => MessagesSection(), section)
						),
						// SectionTile(
						// 	name: QuestionsSection.name,
						// 	icon: QuestionsSection.icon,
						// 	setSection: _setSectionFunction(() => QuestionsSection(), section)
						// ),
						SectionTile(
							name: GroupSection.name,
							icon: GroupSection.icon,
							setSection: _setSectionFunction(() => GroupSection(), section)
						),
						// const ListTile(),
						// SectionTile(
						// 	name: SettingsSection.name,
						// 	icon: SettingsSection.icon,
						// 	setSection: _setSectionFunction(() => const SettingsSection(), section)
						// )
					]
				)
			),
			drawerEdgeDragWidth: 150,
			floatingActionButton: section.value.actionButton
		);
	}

	void Function() _setSectionFunction<S extends Section>(
		S Function() sectionBuilder,
		ValueNotifier<Section> section
	) => () {
		if (section.value is! S) section.value = sectionBuilder();
	};
}


// class EntityCount extends StatelessWidget {
// 	final Future<int> future;

// 	const EntityCount(this.future);

// 	@override
// 	Widget build(BuildContext context) {
// 		return FutureBuilder(
// 			future: future,
// 			builder: (context, snapshot) {
// 				if (snapshot.connectionState == ConnectionState.waiting) return Container();
// 				// if (snapshot.hasError) print(snapshot.error);  // todo: consider handling
// 				return Text(snapshot.data!.toString());
// 			}
// 		);
// 	}
// }


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
			},
			style: ListTileStyle.list
		);
	}
}
