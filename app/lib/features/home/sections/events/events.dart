import 'package:flutter/material.dart';

import '../../section.dart';


class EventsSection extends HomeSection {
	const EventsSection();

	@override
	final String name = "events";
	@override
	final IconData icon = Icons.event;
	@override
	final IconData inactiveIcon = Icons.event_outlined;
}
