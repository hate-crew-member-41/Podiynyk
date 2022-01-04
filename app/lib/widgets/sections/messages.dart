import 'package:flutter/material.dart';

import 'section.dart';


class MessagesSection extends Section {
	@override
	final name = "messages";
	@override
	final icon = Icons.messenger;
	@override
	final hasAddAction = true;

	const MessagesSection();

	@override
	Widget build(BuildContext context) {
		return Center(child: Icon(icon));
	}
}
