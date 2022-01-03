import 'package:flutter/material.dart';

import 'section.dart';


class MessagesSection extends Section {
	@override
	final String name = "messages";
	@override
	final IconData icon = Icons.messenger;

	const MessagesSection();

	@override
	Widget build(BuildContext context) {
		return Center(child: Icon(icon));
	}
}
