import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../domain/providers/events.dart';
import '../../../domain/providers/info.dart';

import '../../widgets/counted_icon.dart';
import '../../widgets/home_section_bar.dart';
import '../../widgets/lists/events_list.dart';
import '../../widgets/lists/info_list.dart';

import '../section.dart';


class SeparateSection extends HomeSection {
	const SeparateSection();

	@override
	final String name = "separate";
	@override
	final IconData icon = Icons.bubble_chart;

	@override
	Widget build(BuildContext context, WidgetRef ref) {
		return DefaultTabController(
			length: 2,
			child: Consumer(builder: (context, ref, _) {
				final events = ref.watch(eventsProvider)?.where((event) => event.subject == null);
				final info = ref.watch(infoProvider);

				return Scaffold(
					appBar: HomeSectionBar(
						name: name,
						icon: icon,
						tabs: [
							// do: define a widget
							Tab(child: CountedIcon(icon: Icons.notes, count: info?.length)),
							Tab(child: CountedIcon(icon: Icons.event, count: events?.length))
						]
					),
					body: TabBarView(children: [
						InfoList(info),
						EventsList(events)
					])
				);
			})
		);
	}
}
