import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../domain/providers/events.dart';
import '../../../domain/providers/info.dart';

import '../../widgets/bars/counted_icon.dart';
import '../../widgets/bars/entity_lists_tab_bar.dart';
import '../../widgets/bars/section_bar.dart';
import '../../widgets/info/list.dart';

import '../../state.dart';
import '../events/list.dart';


class SeparateSection extends ConsumerWidget {
	const SeparateSection();

	@override
	Widget build(BuildContext context, WidgetRef ref) {
		final info = ref.watch(infoProvider);
		final events = ref.watch(eventsProvider)?.where((e) => e.subject == null);

		return DefaultTabController(
			length: 2,
			child: Scaffold(
				appBar: SectionBar(
					section: Section.separate,
					bottom: EntityListsTabBar(tabIcons: [
						CountedIcon(
							icon: Icons.notes,
							count: info?.length
						),
						CountedIcon(
							icon: Section.events.icon,
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
