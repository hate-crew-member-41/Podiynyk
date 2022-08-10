import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'sections/events/section.dart';
import 'sections/me/section.dart';
import 'sections/messages/section.dart';
import 'sections/separate/section.dart';
import 'sections/groupmates/section.dart';
import 'sections/subjects/section.dart';


enum Section {
	events(
		name: "events",
		icon: Icons.event,
		widget: EventsSection()
	),
	subjects(
		name: "subjects",
		icon: Icons.school,
		widget: SubjectsSection()
	),
	separate(
		name: "separate",
		icon: Icons.bubble_chart,
		widget: SeparateSection()
	),
	messages(
		name: "messages",
		icon: Icons.chat,
		widget: MessagesSection()
	),
	students(
		name: "group",
		icon: Icons.people,
		widget: GroupmatesSection()
	),
	settings(
		name: "me",
		icon: Icons.person,
		widget: MeSection()
	);

	const Section({
		required this.name,
		required this.icon,
		required this.widget
	});

	final String name;
	final IconData icon;
	final Widget widget;
}

final homeStateProvider = StateProvider<Section>((ref) => Section.events);
