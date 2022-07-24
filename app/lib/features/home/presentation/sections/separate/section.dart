import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../domain/providers/events.dart';
import '../../../domain/providers/info.dart';

import '../../widgets/bars/counted_icon.dart';
import '../../widgets/bars/entity_lists_tab_bar.dart';
import '../../widgets/bars/home_section_bar.dart';
import '../../widgets/info/list.dart';

import '../events/list.dart';
import '../section.dart';


class SeparateSection extends HomeSection {
	const SeparateSection();

	@override
	final String name = "separate";
	@override
	final IconData icon = Icons.bubble_chart;

	@override
	Widget build(BuildContext context, WidgetRef ref) {
		final info = ref.watch(infoProvider);
		final events = ref.watch(eventsProvider)?.where((e) => e.subject == null);

		return DefaultTabController(
			length: 2,
			child: Scaffold(
				appBar: HomeSectionBar(
					name: name,
					icon: icon,
					bottom: EntityListsTabBar(tabIcons: [
						CountedIcon(
							icon: Icons.notes,
							count: info?.length
						),
						CountedIcon(
							icon: Icons.event,
							count: events?.length
						)
					])
				),
				body: TabBarView(children: [
					InfoList(info),
					EventList(events),
				])
			)
		);
	}
}
